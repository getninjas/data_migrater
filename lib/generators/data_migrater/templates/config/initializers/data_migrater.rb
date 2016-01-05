require 'data_migrater'

DataMigrater::Migrator.new.migrate unless Rails.env.test?
