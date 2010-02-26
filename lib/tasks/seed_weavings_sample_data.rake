namespace :db do
  namespace :seed do
    desc "Add some sample data to the database."
    task :weavingssampledata => :environment do
      # Create some initial pages the Weavings Module will need for portlets etc.
      class LoadWeavingsSampleData
        Weaver.create(:name => 'Joe', :last_name => 'Bloggs', :description => 'An awesome weaver.').publish!
        WeavingType.create(:name => 'Rug', :spanish_name => 'foo', :low_stock_level => 10, :user_id => 0, :description => 'You can stand on it').publish!
        WoolType.create(:name => 'Sheep', :description => 'Some pretty common wool').publish!
        Weaving.create(:item_number => '001', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
          :selling_price => 231.21).publish!
        Weaving.create(:item_number => '002', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
          :selling_price => 40.12).publish!
        Weaving.create(:item_number => '003', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
          :selling_price => 432).publish!
        Weaving.create(:item_number => '004', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
          :selling_price => 3).publish!
        Weaving.create(:item_number => '005', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
          :selling_price => 95).publish!
        Weaving.create(:item_number => '006', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
          :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
          :selling_price => 1).publish!

        # Set up some portlets
        set_up_portlet "recent_weavings_portlet", 'app/views/portlets/recent_weavings/render.html.erb',
          { "name" => "Last 10 Weavings", "connect_to_page_id" => Page.find_by_path('/weavings/weavings').id, :limit => 10 }

        set_up_portlet "cart_portlet", 'app/views/portlets/cart/render.html.erb',
          { "name" => "Cart", "connect_to_page_id" => Page.find_by_path('/weavings/weavings').id }

        set_up_portlet "orders_portlet", 'app/views/portlets/orders/render.html.erb',
          { "name" => "Orders", "connect_to_page_id" => Page.find_by_path('/weavings/weavings').id, :results_per_page => 50 }

        set_up_portlet "browse_weavings_portlet", 'app/views/portlets/browse_weavings/render.html.erb',
          { "name" => "Browse Weavings", "connect_to_page_id" => Page.find_by_path('/weavings/items-for-sale').id, :results_per_page => 20 }
      end
    end
  end
  private
  def set_up_portlet portlet_name, template_path, portlet_arguments
    template_file = RAILS_ROOT + '/' + template_path
    template = ''
    # If the template file does not exist we are running out of the gem so grab the template file from there
    # TODO: Implement this in a more robust way
    template_file = '/usr/lib/ruby/gems/1.8/gems/bcms_mano_weavings-1.0.0/' + template_path unless File.exists? template_file
    File.open(template_file, "r") { |f| template = f.read }

    portlet_arguments[:template] = template
    portlet_arguments[:handler] = "erb" unless portlet_arguments[:handler]
    portlet_arguments[:connect_to_container] = "main" unless portlet_arguments[:connect_to_container]
    portlet = portlet_name.classify.constantize.new(portlet_arguments)
    portlet.save
  end
end
