module DataMigrater
  class Collection
    def initialize(path = "#{Rails.root}/db/data_migrate")
      @path = path
    end

    def migrations
      Dir.entries(@path).sort.map do |migration_file|
        migration_for migration_file
      end.compact
    end

    private

    def migration_for(file)
      if file =~ migration_pattern
        DataMigrater::Migration.new $1.to_i, $2, "#{$1}_#{$2}"
      end
    end

    def migration_pattern
      /^([0-9]+)_([_a-z0-9]+)\.rb$/
    end
  end
end
