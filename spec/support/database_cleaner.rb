# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    DataMigration.destroy_all
  end
end
