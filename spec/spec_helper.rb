if ENV.fetch("COVERAGE", false)
  require "simplecov"

  
  if ENV["CIRCLE_ARTIFACTS"]
    dir = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
    SimpleCov.coverage_dir(dir)
  end

SimpleCov.start "rails"
end

require "webmock/rspec"
require "timecop"

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.default_formatter = "doc" if config.files_to_run.one?
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end

WebMock.disable_net_connect!(allow_localhost: true)

# Only allow Timecop with block syntax
Timecop.safe_mode = true
