# frozen_string_literal: true

require 'data_migrater'

unless Rails.env.test? || ENV['DATA_MIGRATER'] == 'false'
  DataMigrater::Migrator.new.migrate
end
