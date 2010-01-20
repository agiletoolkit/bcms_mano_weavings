class OrdersPortlet < Portlet
    
  def render
    # Ensure all google checkout order notifications are processed before rendering
    Order.process_google_checkout_order_notifications
    @orders = Order.find(:all, :order => "created_at desc")
  end
    
end