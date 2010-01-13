module Cms::Routes
  def routes_for_bcms_mano_weavings
    add_weaving_to_cart "/store/add_to_cart", :controller => '/store', :action => 'add_to_cart', :conditions => {:method => :put}
    add_weaving_to_cart "/store/remove_from_cart", :controller => '/store', :action => 'remove_from_cart', :conditions => {:method => :put}
    resources :orders, :new => { :paypal_express => :get }

    namespace(:cms) do |cms|
      cms.content_blocks :weavers
      cms.content_blocks :weavings
      cms.content_blocks :weaving_types
      cms.content_blocks :wool_types
    end
  end
end
