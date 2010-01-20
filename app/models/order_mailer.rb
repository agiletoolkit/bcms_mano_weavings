class OrderMailer < ActionMailer::Base
  def shipment_confirmation(order)
    @recipients = order.email
    @subject = "Your order from Mano A Mano Weavings site has shipped ($" + order.price.to_s + ")"
    @sent_on = Time.now
    @body = { :order => order }
  end
end
