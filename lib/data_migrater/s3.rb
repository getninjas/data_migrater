# frozen_string_literal: true

module DataMigrater
  class S3
    require 'aws-sdk'

    def initialize(bucket:, credentials: {}, file:, tmp_dir:)
      @bucket      = bucket
      @credentials = credentials.reverse_merge(default_credentials)
      @file        = file
      @tmp_dir     = tmp_dir

      ::Aws.config.update @credentials
    end

    def download(processor:)
      File.open(file_path, 'w+') do |file|
        client.get_object options, target: file

        processor.process file
      end
    end

    private

    def client
      Aws::S3::Client.new
    end

    def default_credentials
      {
        access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        region:            ENV['AWS_REGION'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      }
    end

    def file_path
      [@tmp_dir, @file].join('/')
    end

    def options
      { bucket: @bucket, key: @file }
    end
  end
end
