namespace :db do
  namespace :seed do
    desc "Add some sample data to the database."
    task :weavingssampledata => :environment do
      # Create some initial pages the Weavings Module will need for portlets etc.
      class LoadWeavingsSampleData
        Weaver.create(:name => 'Joe', :last_name => 'Bloggs', :description => 'An awesome weaver.').publish!
        WeavingType.create(:name => 'Rug', :spanish_name => 'foo', :low_stock_level => 10, :user_id => 0, :description => 'You can stand on it').publish!
        WoolType.create(:name => 'Sheep', :description => 'Some pretty common wool').publish!
        Weaving.create(:name => 'W001', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bol => 32.21,
          :selling_price => 231.21).publish!
        Weaving.create(:name => 'W002', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bol => 32.21,
          :selling_price => 40.12).publish!
        Weaving.create(:name => 'W003', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bol => 32.21,
          :selling_price => 432).publish!
        Weaving.create(:name => 'W004', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bol => 32.21,
          :selling_price => 3).publish!
        Weaving.create(:name => 'W005', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bol => 32.21,
          :selling_price => 95).publish!
        Weaving.create(:name => 'W006', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bol => 32.21,
          :selling_price => 1).publish!

        # Create the recent weavings portlet and put it on the /weavings/weavings page
        template = ''
        File.open(File.join(File.dirname(__FILE__), '..', 'app', 'views', 'portlets', 'recent_weavings', 'render.html.erb'), "r") { |f| template = f.read }
        portlet = "recent_weavings_portlet".classify.constantize.new("name" => "Last 10 Weavings", "connect_to_page_id" => Page.find_by_path('/weavings/weavings').id, "handler" => "erb", "template" => template, "limit" => 10, "connect_to_container" => "main")
        portlet.save

        # Create the cart portlet and put it on the /weavings/weavings page
        File.open(File.join(File.dirname(__FILE__), '..', 'app', 'views', 'portlets', 'cart', 'render.html.erb'), "r") { |f| template = f.read }
        portlet = "cart_portlet".classify.constantize.new("name" => "Cart", "connect_to_page_id" => Page.find_by_path('/weavings/weavings').id, "handler" => "erb", "template" => template, "connect_to_container" => "main")
        portlet.save
      end
    end
  end
end