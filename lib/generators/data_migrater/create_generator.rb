# frozen_string_literal: true

module DataMigrater
  class CreateGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :name, type: :string

    desc 'create a skeleton data migration.'

    def create_migrate_file
      tmpl    = 'db/data_migrate/data_migrate.rb.erb'
      version = Time.zone.now.strftime '%Y%m%d%H%M%S'

      template tmpl, "db/data_migrate/#{version}_#{name.underscore}.rb"
    end
  end
end
