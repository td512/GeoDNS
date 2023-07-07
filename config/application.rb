require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Login
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # Postmark
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { :api_token => "3291fe29-ce78-4621-9e1a-6ee2215a5ae6" }
    config.exceptions_app = self.routes
  end
end
