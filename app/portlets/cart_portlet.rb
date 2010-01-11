class CartPortlet < Portlet
  def render
    if(session[:cart_id] && Cart.exists?(session[:cart_id]))
      @weavings_in_cart = Cart.find(session[:cart_id]).weavings
    else
      @weavings_in_cart = []
    end
  end
end
