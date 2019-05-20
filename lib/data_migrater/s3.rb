# frozen_string_literal: true

module DataMigrater
  class S3
    require 'aws-sdk-s3'

    def initialize(bucket:, credentials:, key:, tmp_dir:)
      @bucket      = bucket
      @credentials = default_credentials.merge(credentials)
      @key         = key
      @tmp_dir     = tmp_dir

      ::Aws.config.update @credentials
    end

    def download
      client.head_object options

      File.open(file_path, 'w+') do |file|
        client.get_object options, target: file

        file 
      end
    rescue Aws::S3::Errors::NotFound
      []
    end

    private

    def client
      Aws::S3::Client.new
    end

    def default_credentials
      {
        access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        region:            ENV.fetch('AWS_REGION', 'us-east-1'),
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      }
    end

    def file_path
      [@tmp_dir, @key].join('/')
    end

    def options
      { bucket: @bucket, key: @key }
    end
  end
end
