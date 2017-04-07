module DataMigrater
  module Logger
    extend ActiveSupport::Concern

    included do
      def logger
        return @logger if @logger

        @logger = ::Logger.new(logger_path)

        @logger.formatter = formatter

        @logger
      end

      def logger_path
        return logger_options[:path] if logger_options[:path].present?

        [logger_dir, logger_file].join "/"
      end

      private

      def formatter
        -> (severity, datetime, _progname, message) do
          "[#{datetime}] #{severity} #{self.class.name}: #{message}\n"
        end
      end

      def logger_dir
        logger_options.delete(:dir) || :log
      end

      def logger_file
        logger_options.delete(:file) || "#{self.class.name.underscore}.log"
      end

      def logger_options
        self.class.logger_options
      end
    end

    class_methods do
      def data_logger(options = {})
        @options = options
      end

      def logger_options
        @options || {}
      end
    end
  end
end
