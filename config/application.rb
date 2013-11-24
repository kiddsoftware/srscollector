require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module SrsCollector
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Load front-end JavaScript managed by Bower package manager.  This only
    # works because Sprockets knows a little bit about Bower.
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

    # Explicitly list everything we want in the assets directory, so we don't
    # pick up junk in vendor/assets/components from Bower.
    # See also: https://coderwall.com/p/6bmygq
    config.assets.precompile =
      ['application.js', 'application.css', 'wysihtml5.css',
       /active_admin\/.*\.(png|gif|jpg|jpeg|svg|eot|otf|svc|woff|ttf)$/]

    config.generators do |g|
      g.helper false
      g.test_framework :rspec, fixtures: true, view_specs: false
      g.fixture_replacement :factory_girl
    end
  end
end
