module DataMigrater
  class DataMigrationGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :name, type: :string

    desc "create a skeleton data migration."

    def create_data_migration_file
      tmpl    = 'db/data_migrate/data_migrate.rb.erb'
      version = Time.zone.now.strftime '%Y%m%d%H%M%S'

      template tmpl, "db/data_migrate/#{version}_#{name.underscore}.rb"
    end
  end
end
