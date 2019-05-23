# frozen_string_literal: true

module DataMigrater
  module CSV
    extend ActiveSupport::Concern

    require 'smarter_csv'

    included do
      def csv(processor: ::SmarterCSV)
        s3.download if csv_options.delete(:provider) == :s3

        processor.process csv_path, csv_options
      end

      def csv_path
        return csv_options[:path] if csv_options[:path].present?

        @csv_path ||= [csv_dir, csv_file].join('/')
      end

      def csv_delete
        s3.delete
      end

      private

      def csv_bucket
        csv_options.delete(:bucket) || 'data-migrater'
      end

      def csv_dir
        csv_options.delete(:dir) || 'db/data_migrate/support/csv'
      end

      def csv_file
        csv_options.delete(:file) || "#{self.class.name.underscore}.csv"
      end

      def csv_options
        self.class.csv_options
      end

      def s3_credentials
        csv_options.delete(:credentials) || {}
      end

      def s3
        @s3 ||= DataMigrater::S3.new(csv_bucket, s3_credentials, csv_path)
      end
    end

    module ClassMethods
      def data_csv(options = {})
        @csv_options = options
      end

      def csv_options
        @csv_options || {}
      end
    end
  end
end
