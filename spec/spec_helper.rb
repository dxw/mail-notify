# frozen_string_literal: true

require "simplecov"
require "simplecov-lcov"
SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
SimpleCov.start

require "bundler/setup"
require "action_mailer"
require "pry"
require "webmock/rspec"

require "mail/notify"
require "support/test_mailer"

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
