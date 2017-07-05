# frozen_string_literal: true

module DataMigrater
  module CSV
    extend ActiveSupport::Concern

    require 'smarter_csv'

    included do
      def csv(processor: ::SmarterCSV)
        return s3.download(processor: processor) if csv_s3?

        processor.process csv_path, csv_options
      end

      def csv_path
        return csv_options[:path] if csv_options[:path].present?

        @csv_path ||= [csv_dir, csv_file].join('/')
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

      def csv_s3?
        csv_path.to_s == 's3'
      end

      def csv_tmp_dir
        csv_options.delete(:tmp_dir) || '/tmp'
      end

      def s3_credentials
        csv_options.delete(:credentials) || {}
      end

      def s3
        DataMigrater::S3.new(
          credentials: s3_credentials,
          bucket:      csv_bucket,
          file:        csv_file,
          tmp_dir:     csv_tmp_dir
        )
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
