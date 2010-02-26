class CreateWeavingPhotos < ActiveRecord::Migration
  def self.up
    create_versioned_table :weaving_photos do |t|
      t.belongs_to :attachment
      t.integer :attachment_version
      t.belongs_to :weaving
    end

    # Do not create the menu because Weaving Photos are handeled by the weaving form
    #ContentType.create!(:name => "WeavingPhoto", :group_name => "WeavingPhoto")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'WeavingPhoto'])
    CategoryType.all(:conditions => ['name = ?', 'Weaving Photo']).each(&:destroy)
    #If you aren't creating a versioned table, be sure to comment this out.
    drop_table :weaving_photo_versions
    drop_table :weaving_photos
  end
end
