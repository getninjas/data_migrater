# frozen_string_literal: true

module DataMigrater
  class Migrator
    def initialize(collection = DataMigrater::Collection.new)
      @collection = collection
    end

    def migrate
      return unless DataMigration.table_exists?

      begin
        ActiveRecord::Migration.check_pending!

        ActiveRecord::Base.transaction do
          @collection.migrations.each(&:execute)
        end
      rescue ActiveRecord::PendingMigrationError
        puts "DataMigrater stopped. Pending migrations need to executed!"
      end
    end
  end
end
