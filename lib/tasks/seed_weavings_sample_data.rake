namespace :db do
  namespace :seed do
    desc "Add some sample data to the database."
    task :weavingssampledata => :environment do
      # Create some initial pages the Weavings Module will need for portlets etc.
      class LoadWeavingsSampleData
        Weaver.create(:name => 'Joe', :last_name => 'Bloggs', :description => 'An awesome weaver.').publish!
        WeavingType.create(:name => 'Rug', :spanish_name => 'foo', :low_stock_level => 10, :user_id => 0, :description => 'You can stand on it').publish!
        WoolType.create(:name => 'Sheep', :description => 'Some pretty common wool').publish!
        Weaving.create(:name => '8192', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bol => 32.21, 
          :selling_price => 123.23).publish!
      end
    end
  end
end