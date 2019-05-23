# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataMigrater::S3, '.download' do
  subject(:s3) { described_class.new options[:bucket], {}, 'csv_path' }

  let!(:client)  { double('Aws::S3::Client').as_null_object }
  let!(:options) { { bucket: 'data-migrater', key: 'csv_path' } }

  before { allow(Aws::S3::Client).to receive(:new) { client } }

  context 'when file is found' do
    it 'downloads the file' do
      expect(client).to receive(:get_object).with(options.merge(response_target: 'csv_path'))

      s3.download
    end

    it 'returns the value of get object' do
      expect(client).to receive(:get_object).with(options.merge(response_target: 'csv_path')).and_return :success

      expect(s3.download).to eq :success
    end
  end

  context 'when file is not found' do
    let!(:error) { Aws::S3::Errors::NotFound.new 'error', 'message' }

    before { allow(client).to receive(:head_object).with(options).and_raise error }

    it 'returns an empty array' do
      expect(s3.download).to eq []
    end
  end
end
