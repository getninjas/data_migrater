# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataMigrater::S3, '.download' do
  subject(:s3) { described_class.new options.merge(credentials: {}, tmp_dir: '/tmp') }

  let!(:client)  { double('Aws::S3::Client').as_null_object }
  let!(:options) { { bucket: 'data-migrater', key: 'dummy.csv' } }

  before { allow(Aws::S3::Client).to receive(:new) { client } }

  context 'when file is found' do
    let!(:file) { instance_double('File').as_null_object }

    before { allow(File).to receive(:open).with('/tmp/dummy.csv', 'w+').and_yield file }

    it 'downloads the file' do
      expect(client).to receive(:get_object).with(options, target: file)

      s3.download
    end

    it 'returns the file' do
      expect(s3.download).to eq file
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
