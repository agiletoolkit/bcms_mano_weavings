# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!
SITE_DOMAIN="localhost:3000"
config.action_view.cache_template_loading = false
config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache/"
config.gem 'google4r-checkout', :lib => 'google4r/checkout' # Used with google checkout

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :production
  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new({
    :login => "production_login",
    :password => "production_password",
    :signature => "production_signature"
  })

  ::GOOGLE_CHECKOUT_CONFIGURATION = {
    :merchant_id => '??',
    :merchant_key => '??',
    :use_sandbox => false
  }
end
