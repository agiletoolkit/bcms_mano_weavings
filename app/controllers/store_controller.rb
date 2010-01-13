class StoreController < ApplicationController
  def add_to_cart
    # FIXME: Using a hack until I can sort out what is going on
    # The following code should look like this
    # cart.weavings << weaving
    # an it should just end up updating weavings and setting the cart_id for the weaving concerned
    # instead it does something funny with the versioning table
    # it would seem this behaviour is caused by something added to the model with acts_as_content_block
    ActiveRecord::Base.connection.execute('UPDATE weavings SET cart_id=' + current_cart.id.to_s + ' WHERE id=' + params["weaving"]["id"].to_s)

    # FIXME: Use the real return path
    redirect_to '/weavings/weavings'
  end

  def remove_from_cart
    # FIXME: Using a hack until I can sort out what is going on
    # Situation similar to the problem in add_to_cart, see comment there for details
    ActiveRecord::Base.connection.execute('UPDATE weavings SET cart_id = null WHERE id = ' + params["weaving"]["id"].to_s)

    # FIXME: Use the real return path
    redirect_to '/weavings/weavings'
  end
end
