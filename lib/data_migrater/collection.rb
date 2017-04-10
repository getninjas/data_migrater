# frozen_string_literal: true

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
        DataMigrater::Migration.new Regexp.last_match(1).to_i, Regexp.last_match(2), "#{Regexp.last_match(1)}_#{Regexp.last_match(2)}"
      end
    end

    def migration_pattern
      /^([0-9]+)_([_a-z0-9]+)\.rb$/
    end
  end
end
