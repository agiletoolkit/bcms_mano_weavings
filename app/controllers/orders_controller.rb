class OrdersController < ApplicationController
  def paypal_express
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    response = EXPRESS_GATEWAY.setup_purchase(cart.total_price_in_cents,
      :ip                => request.remote_ip,
      :return_url        => new_order_url + '?pp=pp',
      :cancel_return_url => 'http://192.168.56.64:3000/weavings/weavings' #should go to list of weavings, maybe add to admin section of browsercms if possible
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    if(params[:pp] == 'pp')
      @order = Order.new(:paypal_express_token => params[:token], :cart => cart, :payment_processor => 'paypal_express')
    else
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
      @order = cart.order
    end
  end

  def charge
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    # Google checkout creates an order using the polling api
    @order = cart.order
    if(!@order)
      @order = cart.build_order(params[:order])
      @order.payment_processor = 'paypal_express'
    end

    @order.ip_address = request.remote_ip
    if @order.save
      @transaction = @order.purchase
      if @transaction.success
        render :action => "success"
      else
        render :action => "failure"
      end
    else
      render :action => 'new'
    end
  end

  private
  def request_google_checkout_notification_data_token start_time_utc
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
  def process_google_checkout_notifications continue_token
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
            order.status = 'new'
            order.save
          end
        when Google4R::Checkout::OrderStateChangeNotification
          # Just set the order to whatever state it is in now
          # Google checkout is responsable for sending the notifications in the correct order
          order = Order.find_by_google_order_number notification.google_order_number
          if( order )
            order.status = notification.new_financial_order_state
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
