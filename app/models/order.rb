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
      cart.update_attribute(:purchased_at, Time.now) if response.success?
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
      self.status = 'new'
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
end
