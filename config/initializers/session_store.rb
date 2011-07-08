# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_login_last_session',
  :secret      => '1f0d51ac4a53763e8b3e4f4bff4f7c26792eac1cbf36396b6f7924e1bbb054b4a5df3496fe918742e9e75d7ec99de827da2ceedbdb39472d14934f2e2edad12a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
