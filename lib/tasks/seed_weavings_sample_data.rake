namespace :db do
  namespace :seed do
    desc "Create pages and portlets required by the weavings module."
    task :weavings => :environment do
      class LoadWeavingsSeedData
        extend Cms::DataLoader

        # Set up the sections and pages
        create_section(:weavings, :name => "Weavings", :parent => Section.find_by_path("/"), :path => "/weavings")
        create_section(:administration, :name => "Administration", :parent => sections(:weavings), :path => "/weavings/administration", :hidden => true)
        Group.all.each{|g| g.sections = Section.all }
        # Remove the guest user from the weavings administration
        sections(:administration).groups.delete Group.find_by_code('guest')
        sections(:administration).save

        # Use the home page template if it exists otherwise use default
        template_file_name = File.exists?('app/views/layouts/templates/home_page.html.erb') ? 'home_page.html.erb' : 'default.html.erb'

        # Public section
        create_page(:overview, :name => "Overview", :path => "/weavings", :section => sections(:weavings), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:weaving_process, :name => "Weaving Process", :path => "/weavings/weaving-process", :section => sections(:weavings), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:weavers, :name => "Weavers", :path => "/weavings/weavers", :section => sections(:weavings), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:weavings, :name => "Weavings", :path => "/weavings/weavings", :section => sections(:weavings), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:weaving, :name => "Weaving", :path => "/weavings/weaving", :section => sections(:weavings), :template_file_name => template_file_name, :publish_on_save => true, :hidden => true, :cacheable => true)
        create_page(:items_for_sale, :name => "Items for Sale", :path => "/weavings/items-for-sale", :section => sections(:weavings), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)
        create_page(:donate, :name => "Donate", :path => "/weavings/donate", :section => sections(:weavings), :template_file_name => template_file_name, :publish_on_save => true, :hidden => false, :cacheable => true)

        # Administration section
        create_page(:orders, :name => "Orders", :path => "/weavings/administration/orders", :section => sections(:administration), :template_file_name => template_file_name, :publish_on_save => true, :hidden => true, :cacheable => true)

        # Set up some portlets
        set_up_portlet "recent_weavings_portlet", 'app/views/portlets/recent_weavings/render.html.erb',
          { "name" => "What's New?", "connect_to_page_id" => Page.find_by_path('/weavings/weavings').id, :limit => 10 }

        set_up_portlet "cart_portlet", 'app/views/portlets/cart/render.html.erb',
          { "name" => "Cart", "connect_to_page_id" => Page.find_by_path('/weavings/weavings').id }

        set_up_portlet "orders_portlet", 'app/views/portlets/orders/render.html.erb',
          { "name" => "Orders", "connect_to_page_id" => Page.find_by_path('/weavings/administration/orders').id, :results_per_page => 50 }

        set_up_portlet "browse_weavings_portlet", 'app/views/portlets/browse_weavings/render.html.erb',
          { "name" => "Browse Weavings", "connect_to_page_id" => Page.find_by_path('/weavings/items-for-sale').id, :results_per_page => 20 }

        set_up_portlet "weaving_details_portlet", 'app/views/portlets/weaving_details/render.html.erb',
          { "name" => "Weaving Details", "connect_to_page_id" => Page.find_by_path('/weavings/weaving').id }
      end
    end

    desc "Add some sample data to the database."
      task :sampledata => :environment do
        class LoadWeavingsSampleData
          # Make sure the relevant pages exist
          Rake::Task['db:seed:weavings'].invoke

          Weaver.create(:name => 'Joe', :last_name => 'Bloggs', :description => 'An awesome weaver.').publish!
          WeavingType.create(:name => 'Rug', :spanish_name => 'foo', :low_stock_level => 10, :user_id => 0, :description => 'You can stand on it').publish!
          WoolType.create(:name => 'Sheep', :description => 'Some pretty common wool').publish!
          counter = 1
          w = Weaving.create(:item_number => '001', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
            :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 231.21, :summary_description => 'Summary goes here.', :description => 'Description of weaving here.', :published => true)
          set_up_weaving_photos w, counter ; counter += 3
          w = Weaving.create(:item_number => '002', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
            :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 40.12, :summary_description => 'Summary goes here.', :description => 'Description of weaving here.', :published => true)
          set_up_weaving_photos w, counter ; counter += 3
          w = Weaving.create(:item_number => '003', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
            :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 432, :summary_description => 'Summary goes here.', :description => 'Description of weaving here.', :published => true)
          set_up_weaving_photos w, counter ; counter += 3
          w = Weaving.create(:item_number => '004', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
            :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 3, :summary_description => 'Summary goes here.', :description => 'Description of weaving here.', :published => true)
          set_up_weaving_photos w, counter ; counter += 3
          w = Weaving.create(:item_number => '005', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
            :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 95, :summary_description => 'Summary goes here.', :description => 'Description of weaving here.', :published => true)
          set_up_weaving_photos w, counter ; counter += 3
          w = Weaving.create(:item_number => '006', :weaver_id => Weaver.find_by_name('Joe', :first).id, :weaving_type_id => WeavingType.find_by_name('Rug', :first).id,
            :wool_type_id => WoolType.find_by_name('Sheep', :first).id, :purchase_price_usd => 123.43, :purchase_price_bob => 32.21,
            :selling_price => 1, :summary_description => 'I should have an image.', :description => 'Description of weaving here.', :published => true)
          set_up_weaving_photos w, counter ; counter += 3
          end
      end
  end
  private
  def set_up_weaving_photos weaving, start_index
    count = start_index
    set_up_weaving_photo weaving, 'weavings_test_photos/' + count.to_s + '.jpg', 'weaving_photo_front_' + weaving.id.to_s + '.jpg', 'photo_for_weaving_' + weaving.id.to_s + '_front.jpg'
    count += 1
    set_up_weaving_photo weaving, 'weavings_test_photos/' + count.to_s + '.jpg', 'weaving_photo_back_' + weaving.id.to_s + '.jpg', 'photo_for_weaving_' + weaving.id.to_s + '_back.jpg'
    count += 1
    set_up_weaving_photo weaving, 'weavings_test_photos/' + count.to_s + '.jpg', 'weaving_photo_misc_' + weaving.id.to_s + '.jpg', 'photo_for_weaving_' + weaving.id.to_s + '_misc.jpg'
  end

  def set_up_weaving_photo weaving, file_path, original_name, weaving_photo_name
    require 'test_help'
    tempfile = ActionController::UploadedTempfile.new(original_name)
    realfile = File.open file_path
    open(tempfile.path, 'w') {|f| f << realfile.read}
    tempfile.original_path = original_name
    tempfile.content_type = 'image/jpeg'

    photo_front = WeavingPhoto.new :name => weaving_photo_name, :attachment_file => tempfile, :published => true
    photo_front.weaving = weaving
    photo_front.save
    photo_front.publish!
  end

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
