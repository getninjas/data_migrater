require 'rspec/rails'

RSpec.configure do |config|
  config.filter_run_when_matching :focus

  config.order = :random
end
