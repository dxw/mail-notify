# frozen_string_literal: true

require "simplecov"
require "simplecov-lcov"

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter
])
SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.start

require "bundler/setup"
require "action_controller"
require "action_mailer"
require "debug"

require "mail/notify"

# we have to trick ActionMailer into looking for our test email view templates
ActionMailer::Base.view_paths = File.join(File.dirname(__FILE__), "support", "templates")

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
