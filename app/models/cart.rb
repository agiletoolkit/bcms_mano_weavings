class Cart < ActiveRecord::Base
  has_many :weavings
  has_one :order

  def total_price
    total = 0
    weavings.each do |weaving|
      total += weaving.selling_price
    end
    total
  end

  def total_price_in_cents
    (total_price * 100).to_i
  end

  # Returns the current cart if the user has one or nill if they don't have a cart yet
  def self.current_cart(session)
    if(session[:cart_id] && Cart.exists?(session[:cart_id]))
      cart = Cart.find(session[:cart_id])

      # Throw away this cart because the user should not be adding weavings to a purchased cart
      if(cart.purchased_at)
        cart = nil
        session[:cart_id] = cart
      end
    else
      # Don't create a cart for a visitor if they don't have a cart_id
      # The cart will be created the first time they click on an "Add to Cart" button
      cart = nil
    end
    cart
  end
end
