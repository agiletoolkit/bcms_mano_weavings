class CreateCarts < ActiveRecord::Migration
  def self.up
    create_table :carts do |t|
      t.has_many :weavings
      t.timestamps
    end
  end

  def self.down
    drop_table :carts
  end
end
