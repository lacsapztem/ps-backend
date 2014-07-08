# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
PsBackend::Application.config.secret_key_base = '08cd8725edbe5cd40907c34b622c87de1bbf03790026637d1ac53e47a74a971f44213df4ac6e4a5da5ec41ba8850bdd518658a378a8bb8a04e8c2382422136d6'
