ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true,
  :user_name => "mano.cart.test.merchant@gmail.com",
  :password => "puthe3habreq2ZacuStecR2x38WuGAsw",
  :host => "mano.cart.test.merchant@gmail.com"
}