class OrdersController < ApplicationController
  def paypal_express
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    response = EXPRESS_GATEWAY.setup_purchase(cart.total_price_in_cents,
      :ip                => request.remote_ip,
      :return_url        => new_order_url + '?pp=pp',
      :cancel_return_url => 'http://192.168.56.64:3000/weavings/weavings' #should go to list of weavings, maybe add to admin section of browsercms if possible
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    if(params[:pp] == 'pp')
      @order = Order.new(:paypal_express_token => params[:token], :cart => cart, :payment_processor => 'paypal_express')
    else
      # Process any orders retrieved through the google checkout polling api
      Order.process_google_checkout_order_notifications
      @order = cart.order
    end
  end

  def charge
    # Assume the current cart exists
    cart = Cart.current_cart(session)
    # Google checkout creates an order using the polling api
    @order = cart.order
    if(!@order)
      @order = cart.build_order(params[:order])
      @order.payment_processor = 'paypal_express'
      @order.financial_state = 'CHARGEABLE'
      @order.fulfillment_state = 'NEW'
    end

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

  def ship
    order = Order.find(params["order"]["id"])
    order.carrier = params["order"]["carrier"]
    order.carrier_tracking_number = params["order"]["carrier_tracking_number"]

    if(order.payment_processor == 'paypal_express')
      # Create and send shipment confirmation email
      OrderMailer.deliver_shipment_confirmation(order)

      # Mimic the google checkout behavour (since paypal does not do shipping)
      order.fulfillment_state = 'DELIVERED'

      # TODO: Set a shipped at field to now (or make a transaction)
      # TODO: Set an archived_at field to now
    else
      # Deliver the order
      frontend = Google4R::Checkout::Frontend.new(GOOGLE_CHECKOUT_CONFIGURATION)
      frontend.tax_table_factory = GoogleCheckoutTaxTableFactory.new
      deliver_order_command = frontend.create_deliver_order_command
      deliver_order_command.google_order_number = order.google_order_number
      deliver_order_command.send_email = true
      deliver_order_command.carrier = order.carrier
      deliver_order_command.tracking_number = order.carrier_tracking_number
      deliver_order_command.send_to_google_checkout
      order.save

      # Archive the order
      archive_order_command = frontend.create_archive_order_command
      archive_order_command.google_order_number = order.google_order_number
      archive_order_command.send_to_google_checkout

      # TODO: Maybe create a transaction
      # TODO: Might want to update an archived_at field so we can filter old order out when displaying them
    end
    order.save
    flash[:notice] = "Shipped and archived order totalling $" + order.price.to_s
    redirect_to '/weavings/weavings'
  end
end
