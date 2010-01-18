class CreateGoogleCheckoutPollings < ActiveRecord::Migration
  def self.up
    create_table :google_checkout_pollings do |t|
      t.string :notification_data_token

      t.timestamps
    end
  end

  def self.down
    drop_table :google_checkout_pollings
  end
end
