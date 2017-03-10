RSpec.configure do |config|
  config.before do
    DataMigration.destroy_all
  end

  config.after :suite do
    File.delete File.expand_path("../../dummy.log", __dir__)
  end
end
