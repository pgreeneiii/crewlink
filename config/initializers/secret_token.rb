# config/initializers/secret_token.rb
Crewlink::Application.config.secret_key_base = ENV['SECRET_TOKEN']
