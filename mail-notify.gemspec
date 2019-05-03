# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail/notify/version'

Gem::Specification.new do |spec|
  spec.name          = 'mail-notify'
  spec.version       = Mail::Notify::VERSION
  spec.authors       = ['Stuart Harrison']
  spec.email         = ['pezholio@gmail.com']

  spec.summary       = 'ActionMailer support for the GOV.UK Notify API'
  spec.homepage      = 'https://github.com/dxw/mail-notify'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'coveralls', '~> 0.8.22'
  spec.add_development_dependency 'pry', '~> 0.12.0'
  spec.add_development_dependency 'rails', '~> 5.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.63'
  spec.add_development_dependency 'sqlite3', '~> 1.4.1'

  spec.add_dependency 'actionmailer', '~> 5.0'
  spec.add_dependency 'notifications-ruby-client', '~> 3.1'
end
