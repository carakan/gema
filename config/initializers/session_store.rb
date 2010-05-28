# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gema_session',
  :secret      => '0c547dfc76ee498d0d1d950ff9abf80549442c74b59787aca481dbeae717f0bdc9075cce276f946b498a6f4f15024c5bc23f1e41ca39136dea16e84a5605c230'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
