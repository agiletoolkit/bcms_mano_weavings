class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :cart_id
      t.string :financial_state
      t.string :fulfillment_state
      t.string :carrier
      t.string :carrier_tracking_number
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :payer_status
      t.string :ship_to_name
      t.string :ship_to_street_line_1
      t.string :ship_to_street_line_2
      t.string :ship_to_city
      t.string :ship_to_state
      t.string :ship_to_country_code
      t.string :ship_to_country_name
      t.string :ship_to_zip
      t.string :address_status
      t.string :paypal_express_token
      t.string :paypal_express_payer_id
      t.string :payment_processor
      t.string :google_order_number

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
