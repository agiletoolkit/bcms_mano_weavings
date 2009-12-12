class CreateWeavers < ActiveRecord::Migration
  def self.up
    create_content_table :weavers do |t|
      t.string :name
      t.string :last_name
      t.text :description, :size => (64.kilobytes + 1) 
      t.belongs_to :attachment
      t.integer :attachment_version
    end
    
    ContentType.create!(:name => "Weaver", :group_name => "Weavings")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'Weaver'])
    CategoryType.all(:conditions => ['name = ?', 'Weaver']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :weaver_versions
    drop_table :weavers
  end
end
