class OrdersController < ApplicationController
  def paypal_express
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    response = EXPRESS_GATEWAY.setup_purchase(cart.total_price_in_cents,
      :ip                => request.remote_ip,
      :return_url        => new_order_url,
      :cancel_return_url => 'http://192.168.56.64:3000/weavings/weavings' #should go to list of weavings, maybe add to admin section of browsercms if possible
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    @order = Order.new(:paypal_express_token => params[:token], :cart => cart)
  end

  def create
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    @order = cart.build_order(params[:order])
    @order.ip_address = request.remote_ip
    if @order.save
      @transaction = @order.purchase
      if @transaction.success
        render :action => "success"
      else
        render :action => "failure"
      end
    else
      render :action => 'new'
    end
  end
end
