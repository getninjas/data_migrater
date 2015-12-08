module DataMigrater
  class Migration
    attr_reader :version, :name, :filename

    def initialize(version, name, filename, path = "#{Rails.root}/db/data_migrate")
      @filename = filename
      @name     = name
      @path     = path
      @version  = version
    end

    def execute
      data_migration = DataMigration.new version: @version

      return false unless data_migration.valid?

      begin
        data_migration.save!
        migration.execute
      rescue StandardError => e
        data_migration.destroy

        raise e
      end
    end

    private

    def migration
      require_dependency "#{@path}/#{filename}.rb"

      name.camelize.constantize.new
    end
  end
end
