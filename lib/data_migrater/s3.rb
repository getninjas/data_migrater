# frozen_string_literal: true

module DataMigrater
  class S3
    require 'aws-sdk-s3'

    def initialize(bucket, credentials, csv_path)
      @bucket      = bucket
      @credentials = default_credentials.merge(credentials)
      @csv_path    = csv_path

      ::Aws.config.update @credentials
    end

    def delete
      client.delete_object options
    end

    def download
      client.head_object options

      client.get_object options.merge(response_target: @csv_path)
    rescue Aws::S3::Errors::NotFound
      []
    end

    private

    def client
      @client ||= Aws::S3::Client.new
    end

    def default_credentials
      {
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        region: ENV.fetch('AWS_REGION', 'us-east-1'),
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      }
    end

    def options
      { bucket: @bucket, key: @csv_path.split('/').last }
    end
  end
end
