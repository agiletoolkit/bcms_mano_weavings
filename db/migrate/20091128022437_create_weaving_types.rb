class CreateWeavingTypes < ActiveRecord::Migration
  def self.up
    create_versioned_table :weaving_types do |t|
      t.string :name 
      t.string :spanish_name 
      t.integer :low_stock_level 
      t.text :description, :size => (64.kilobytes + 1)
      t.belongs_to :user
      t.belongs_to :attachment
      t.integer :attachment_version
    end

    ContentType.create!(:name => "WeavingType", :group_name => "Weavings")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'WeavingType'])
    CategoryType.all(:conditions => ['name = ?', 'Weaving Type']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :weaving_type_versions
    drop_table :weaving_types
  end
end
