module DataMigrater
  module Logger
    extend ActiveSupport::Concern

    included do
      def logger
        return @logger if @logger

        @logger = ::Logger.new(path)

        @logger.formatter = formatter

        @logger
      end

      private

      def default_path
        "log/#{self.class.name.underscore}.log"
      end

      def formatter
        -> (severity, datetime, _progname, message) do
          "[#{datetime}] #{severity} #{self.class.name}: #{message}\n"
        end
      end

      def options
        self.class.options
      end

      def path
        return default_path unless options

        options.fetch :path, default_path
      end
    end

    class_methods do
      def data_logger(options = {})
        @options = options
      end

      def options
        @options
      end
    end
  end
end
