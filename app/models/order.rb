class Order < ActiveRecord::Base
  belongs_to :cart
  has_many :order_transactions

  def purchase
    if self.payment_processor == 'paypal_express'
      # Handle paypal
      response = EXPRESS_GATEWAY.purchase(price_in_cents, {
        :ip => ip_address,
        :token => paypal_express_token,
        :payer_id => paypal_express_payer_id
      })
      transaction = order_transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
      if response.success?
        cart.update_attribute(:purchased_at, Time.now)
        self.financial_state = 'CHARGED'
        self.save
      end
      transaction
    else
      # Handle google checkout
      front_end = Google4R::Checkout::Frontend.new(GOOGLE_CHECKOUT_CONFIGURATION)
      front_end.tax_table_factory = GoogleCheckoutTaxTableFactory.new

      if front_end
        charge_command = front_end.create_charge_order_command
        # FIXME: Adding on the hardcoded $10 for shipping
        charge_command.amount = Money.new(price_in_cents + 1000)
        charge_command.google_order_number = self.google_order_number
        charge_command.send_to_google_checkout
      end
      # FIXME: Adding the hard coded shipping on here
      transaction = order_transactions.create!(:action => "purchase", :amount => price_in_cents + 10000, :success => true)
      cart.update_attribute(:purchased_at, Time.now)
      transaction
    end
  end

  def price_in_cents
    cart.total_price_in_cents
  end

  def price
    cart.total_price
  end

  def paypal_express_token=(token)
    write_attribute(:paypal_express_token, token)
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.financial_state = 'NEW'
      self.fulfillment_state = 'NEW'
      self.paypal_express_payer_id = details.payer_id
      self.first_name = details.params["first_name"]
      self.last_name = details.params["last_name"]
      self.email = details.params["payer"]
      self.payer_status = details.params["payer_status"]
      self.ship_to_name = details.params["name"]
      self.ship_to_street_line_1 = details.params["street1"]
      self.ship_to_street_line_2 = details.params["street2"]
      self.ship_to_city = details.params["city_name"]
      self.ship_to_state = details.params["state_or_province"]
      self.ship_to_country_code = details.params["payer_country"]
      self.ship_to_country_name = details.params["country_name"]
      self.ship_to_zip = details.params["postal_code"]
      self.address_status = details.params["address_status"]
    end
  end

  def self.process_google_checkout_order_notifications
    # FIXME: Ensure that this is only run once (i.e. put a mutex or something on the singleton so that we can never have 2 requests talking to the google servers)
    continue_token = GoogleCheckoutPolling.instance.notification_data_token
    if !continue_token
      # Request all notifications after now during development when the database will be destroyed a lot
      # replace with Time.parse("Jan 2010") or similar later to get everything for this year
      # Google says the requests must be at least 5 minutes in the past
      continue_token = request_google_checkout_notification_data_token 6.minutes.ago.getutc
    end

    # Use the google checkout polling api to process all notifications
    # If there is a notification for the current users cart it will be processed now
    process_google_checkout_notifications continue_token
  end

  # Taken from valid values for the carrier tag found here http://code.google.com/apis/checkout/developer/Google_Checkout_XML_API_Order_Level_Shipping.html#Deliver_Order
  def self.carriers
    [
      :DHL,
      :FedEx,
      :UPS,
      :USPS,
      :Other
    ]
  end

  private
  def self.request_google_checkout_notification_data_token start_time_utc
    require 'net/https'
    require 'uri'
    require 'rexml/document'

    # Create the notification-data-token-request xml
    token_request_xml = REXML::Document.new
    declaration = REXML::XMLDecl.new
    declaration.encoding = 'utf-8'
    token_request_xml << declaration
    root = token_request_xml.add_element 'notification-data-token-request'
    root.add_attribute('xmlns', 'http://checkout.google.com/schema/2')
    start_time = root.add_element 'start-time'
    start_time.text = start_time_utc.strftime "%Y-%m-%dT%H:%M:%S"
    #start_time.text = '2009-12-10T14:00:00'

    # Post the request xml to google checkout
    uri = URI.parse('https://' + (GOOGLE_CHECKOUT_CONFIGURATION[:use_sandbox] ? 'sandbox.google.com/checkout/api/checkout/v2/reports/Merchant/' : 'checkout.google.com/api/checkout/v2/reports/Merchant/') + GOOGLE_CHECKOUT_CONFIGURATION[:merchant_id])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # Don't verify now because we don't have google's certificate
    # An example of loading a .pem file with a certificate is below
    #http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    #http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
    data = nil
    http.start {
      req = Net::HTTP::Post.new(uri.path)
      req.basic_auth GOOGLE_CHECKOUT_CONFIGURATION[:merchant_id], GOOGLE_CHECKOUT_CONFIGURATION[:merchant_key]
      resp, data = http.request(req, token_request_xml.to_s)
    }

    # Get the continue-token out of google's response
    r = REXML::Document.new data
    continue_token = r.root.elements['continue-token'].text

    # Save the continue_token to the database
    polling = GoogleCheckoutPolling.instance
    polling.notification_data_token = continue_token
    polling.save
    continue_token
  end

  # Processes all google checkout notifications using the polling api
  def self.process_google_checkout_notifications continue_token
    # Construct xml to request notifications
    notification_data_request = REXML::Document.new
    declaration = REXML::XMLDecl.new
    declaration.encoding = 'utf-8'
    notification_data_request << declaration
    root = notification_data_request.add_element 'notification-data-request'
    root.add_attribute('xmlns', 'http://checkout.google.com/schema/2')
    continue_token_element = root.add_element 'continue-token'
    continue_token_element.text = continue_token

    # Post the request to the google checkout server
    uri = URI.parse('https://' + (GOOGLE_CHECKOUT_CONFIGURATION[:use_sandbox] ? 'sandbox.google.com/checkout/api/checkout/v2/reports/Merchant/' : 'checkout.google.com/api/checkout/v2/reports/Merchant/') + GOOGLE_CHECKOUT_CONFIGURATION[:merchant_id])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # Don't verify now because we don't have google's certificate
    # An example of loading a .pem file with a certificate is below
    #http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    #http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
    data = nil
    http.start {
      req = Net::HTTP::Post.new(uri.path)
      req.basic_auth GOOGLE_CHECKOUT_CONFIGURATION[:merchant_id], GOOGLE_CHECKOUT_CONFIGURATION[:merchant_key]
      resp, data = http.request(req, notification_data_request.to_s)
    }

    # Enumarate the notifications and use the Google4R library to parse them
    frontend = Google4R::Checkout::Frontend.new(GOOGLE_CHECKOUT_CONFIGURATION)
    frontend.tax_table_factory = GoogleCheckoutTaxTableFactory.new
    handler = frontend.create_notification_handler

    r = REXML::Document.new data
    r.root.elements['notifications'].elements.to_a.each do |element|
      notification = handler.handle(element.to_s)
      case notification
        when Google4R::Checkout::NewOrderNotification
          # Build a new order using data provided by google checkout
          cart_id = notification.shopping_cart.private_data['cart_id']

          # TODO: Add some more checks + tests here (is cart purchased)
          if cart_id && Cart.exists?(cart_id)
            cart = Cart.find(cart_id)
            if cart.order
              # Update order information
              order = cart.order
            else
              order = Order.new(:cart => cart, :payment_processor => 'google_checkout')
            end
            order.paypal_express_payer_id = nil
            # FIXME: Find out where the 'Unknown' details are
            order.first_name = 'Unknown'
            order.last_name = 'Unknown'
            order.email = notification.buyer_shipping_address.email
            order.payer_status = 'Unknown'
            order.ship_to_name = notification.buyer_shipping_address.contact_name
            order.ship_to_street_line_1 = notification.buyer_shipping_address.address1
            order.ship_to_street_line_2 = notification.buyer_shipping_address.address2
            order.ship_to_city = notification.buyer_shipping_address.city
            order.ship_to_state = 'Unknown'
            order.ship_to_country_code = notification.buyer_shipping_address.country_code
            order.ship_to_country_name = 'Unknown'
            order.ship_to_zip = notification.buyer_shipping_address.postal_code
            order.address_status = 'Unknown'
            order.google_order_number = notification.google_order_number
            order.financial_state = 'NEW'
            order.fulfillment_state = 'NEW'
            order.save
          end
        when Google4R::Checkout::OrderStateChangeNotification
          # Just set the order to whatever state it is in now
          # Google checkout is responsable for sending the notifications in the correct order
          order = Order.find_by_google_order_number notification.google_order_number
          if( order )
            order.financial_state = notification.new_financial_order_state
            order.fulfillment_state = notification.new_fulfillment_order_state
            order.save
          end
        when Google4R::Checkout::RiskInformationNotification
          # Ignore for now
        when Google4R::Checkout::ChargeAmountNotification
          # TODO: Check notification.total_charge_amount against the orders shopping cart total
        end
    end

    # Save the new continue_token to the database so we get new notifications next time this is called
    polling = GoogleCheckoutPolling.instance
    polling.notification_data_token = r.root.elements['continue-token'].text
    polling.save

    # TODO: Check the has more notifications field
  end
end
