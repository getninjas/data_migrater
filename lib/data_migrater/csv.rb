module DataMigrater
  module CSV
    extend ActiveSupport::Concern

    require "smarter_csv"

    included do
      def csv
        result = ::SmarterCSV.process(csv_path, csv_options)

        result
      end

      def csv_path
        return csv_options[:path] if csv_options[:path].present?

        [csv_dir, csv_file].join "/"
      end

      private

      def csv_dir
        csv_options.delete(:dir) || "data_migrater/support/csv"
      end

      def csv_file
        csv_options.delete(:file) || "#{self.class.name.underscore}.csv"
      end

      def csv_options
        self.class.csv_options
      end
    end

    module ClassMethods
      def data_csv(options = {})
        @options = options
      end

      def csv_options
        @options || {}
      end
    end
  end
end
