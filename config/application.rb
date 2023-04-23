require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails-i18n"
require 'http_errors'

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    config.active_record.legacy_connection_handling = false
    config.action_controller.urlsafe_csrf_tokens = true

    config.i18n.available_locales = [:en, :de]
    config.i18n.default_locale = :en
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.time_zone = 'Berlin'
    config.active_record.default_timezone = :utc
    # Configuration for the application, engines, and railties goes here.
    #/home/mahmoud/Desktop/projects/myapp/config/application.rb
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    # config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }

    # Insert Rack::Cors middleware before all other middleware
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        # Allow requests from any origin
        origins '*'

        # Allow all HTTP methods (GET, POST, PUT, DELETE, OPTIONS)
        # and any headers
        resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
      end
    end

     # Use FactoryBot for fixture replacement
     config.generators do |g|
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.autoload_paths << Rails.root.join('lib')
  end
end
