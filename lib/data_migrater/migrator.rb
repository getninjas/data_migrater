module DataMigrater
  class Migrator
    def initialize(collection = DataMigrater::Collection.new)
      @collection = collection
    end

    def migrate
      ActiveRecord::Base.transaction do
        if execute?
          data_migrations.each(&:execute)
        else
          pending_migrations.each do |migration|
            puts "  #{migration.version} #{migration.name}"
          end
        end
      end
    end

    private

    def execute?
      return false if pending_migrations.any?

      DataMigration.table_exists? && data_migrations.any?
    end

    def data_migrations
      @data_migrations ||= @collection.migrations
    end

    def pending_migrations
      migrations_paths = ActiveRecord::Migrator.migrations_paths
      migrator         = ActiveRecord::Migrator.open migrations_paths

      @pending_migrations ||= migrator.pending_migrations
    end
  end
end
