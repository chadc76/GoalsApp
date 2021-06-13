require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GoalsApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    initializer(:remove_action_mailbox_and_activestorage_routes, after: :add_routing_paths) { |app|
    app.routes_reloader.paths.delete_if {|path| path =~ /activestorage/}
    app.routes_reloader.paths.delete_if {|path| path =~ /actionmailbox/ }
    }

    config.generators do |g|
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.test_framework :rspec,
       fixtures: true,
       view_specs: false,
       helper_specs: false,
       routing_specs: false,
       controller_specs: true,
       request_specs: false
   end
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
