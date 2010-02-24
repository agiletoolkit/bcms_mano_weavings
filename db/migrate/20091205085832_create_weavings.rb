class CreateWeavings < ActiveRecord::Migration
  def self.up
    create_content_table :weavings do |t|
      t.belongs_to :weaver
      t.belongs_to :weaving_type
      t.belongs_to :wool_type
      t.belongs_to :cart
      t.string :item_number
      t.decimal :purchase_price_usd 
      t.decimal :purchase_price_bol 
      t.decimal :selling_price 
      t.text :description, :size => (64.kilobytes + 1) end

    ContentType.create!(:name => "Weaving", :group_name => "Weavings")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'Weaving'])
    CategoryType.all(:conditions => ['name = ?', 'Weaving']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :weaving_versions
    drop_table :weavings
  end
end
