ENV['RAILS_ENV'] ||= 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'active_record/railtie'
require 'data_migrater'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Schema.define do
  create_table :data_migrations do |t|
    t.string :version, null: false
  end
end

RSpec.configure do |config|
  config.before do
    DataMigration.destroy_all
  end
end
