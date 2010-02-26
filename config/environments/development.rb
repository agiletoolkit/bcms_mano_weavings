# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
if !ENV["RUN_CODE_RUN"]
  config.gem 'google4r-checkout', :lib => 'google4r/checkout' # Used with google checkout
end

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
SITE_DOMAIN="localhost:3000"

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new({
    :login => "seller_1263249328_per_api1.gmail.com",
    :password => "MTFH3E75L4GACBJ9",
    :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31AqEv4Qbz7F1Q62PcZ9P0IEuAfqck"
  })

  ::GOOGLE_CHECKOUT_CONFIGURATION = {
    :merchant_id => '340819281290168',
    :merchant_key => '_lqbCFJNb1nc7t45xPeEjg',
    :use_sandbox => true
  }
end
