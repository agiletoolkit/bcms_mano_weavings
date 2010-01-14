class CartPortlet < Portlet
  def render
    @cart = Cart.current_cart(session)
    @weavings_in_cart = []
    if @cart && @cart.weavings
        @weavings_in_cart = @cart.weavings
    end
  end
end
