# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bcms_mano_weavings_session',
  :secret      => 'b685fe34ac2f620f9b6001b462e9eb6e54e6a781f8f588f2336afafd4b04a5f37e555d6e8d8919ac30260d7b56246df96cb15804d86e4f247aee47670f7ce243'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
