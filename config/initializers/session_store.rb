# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bcms_mano_weavings_session',
  :secret      => 'a1b96c4c43e636677b2fc92c992507a877feaf8af51075b042130c8b33ffa88606c35d5a434110687a47d69daf6fdd39dc4005d0ecfb9b64f23ee36746cc7eb8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
