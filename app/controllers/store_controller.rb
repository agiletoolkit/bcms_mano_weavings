class StoreController < ApplicationController
  def add_to_cart
    # Get the cart for this session or create a new one
    if(session[:cart_id] && Cart.exists?(session[:cart_id]))
      cart = Cart.find(session[:cart_id])
    else
      cart = Cart.create!
      session[:cart_id] = cart.id
    end

    # FIXME: Using a hack until I can sort out what is going on
    # The following code should look like this
    # cart.weavings << weaving
    # an it should just end up updating weavings and setting the cart_id for the weaving concerned
    # instead it does something funny with the versioning table
    # it would seem this behaviour is caused by something added to the model with acts_as_content_block
    ActiveRecord::Base.connection.execute('UPDATE weavings SET cart_id=' + cart.id.to_s + ' WHERE id=' + params["weaving"]["id"].to_s)

    # FIXME: Use the real return path
    redirect_to '/weavings/weavings'
  end
end
