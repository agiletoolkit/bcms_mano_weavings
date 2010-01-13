class CartPortlet < Portlet
  def render
    @cart = @current_cart
    if @cart
      @weavings_in_cart = @cart.weavings
    else
      @weavings_in_cart = []
    end
  end
end
