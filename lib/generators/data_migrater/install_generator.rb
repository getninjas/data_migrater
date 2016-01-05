module DataMigrater
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc "creates an initializer and copy necessary files."

    def create_data_folder
      FileUtils.mkdir_p 'db/data_migrate'
      FileUtils.touch   'db/data_migrate/.keep'
    end

    def copy_migrate
      version = Time.zone.now.strftime '%Y%m%d%H%M%S'

      template 'db/migrate/create_data_migrations.rb', "db/migrate/#{version}_create_data_migrations.rb"
    end

    def copy_initializer
      template 'config/initializers/data_migrater.rb', 'config/initializers/data_migrater.rb'
    end
  end
end
