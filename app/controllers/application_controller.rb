# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def current_cart
    if(session[:cart_id] && Cart.exists?(session[:cart_id]))
      @current_cart = Cart.find(session[:cart_id])

      # Create a new cart if the current cart is purchased
      if(@current_cart.purchased_at)
        @current_cart = Cart.create!
        session[:cart_id] = @current_cart.id
      end
    else
      @current_cart = Cart.create!
      session[:cart_id] = @current_cart.id
    end
    @current_cart
  end
end
