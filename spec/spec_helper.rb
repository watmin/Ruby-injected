# frozen_string_literal: true

require 'bundler/setup'
require 'coveralls'
require 'simplecov'
require 'simplecov-cobertura'
require 'pry'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CoberturaFormatter,
    Coveralls::SimpleCov::Formatter
  ]
)

SimpleCov.start do
  refuse_coverage_drop

  add_filter('/spec/')

  minimum_coverage(95)
  coverage_dir('out/coverage')

  enable_coverage :branch
end

require 'injected'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
