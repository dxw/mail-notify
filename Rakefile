# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'coveralls/rake/task'

Coveralls::RakeTask.new
RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

task default: %i[rubocop spec coveralls:push]
