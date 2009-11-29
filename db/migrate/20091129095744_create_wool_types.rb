class CreateWoolTypes < ActiveRecord::Migration
  def self.up
    create_content_table :wool_types do |t|
      t.string :name 
      t.text :description, :size => (64.kilobytes + 1) 
    end

    ContentType.create!(:name => "WoolType", :group_name => "Weavings")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'WoolType'])
    CategoryType.all(:conditions => ['name = ?', 'Wool Type']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :wool_type_versions
    drop_table :wool_types
  end
end
