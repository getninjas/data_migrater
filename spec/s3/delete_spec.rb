# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataMigrater::S3, '.delete' do
  subject(:s3) { described_class.new 'bucket', {}, 'path/dummy.csv' }

  let!(:client) { instance_double('Aws::S3::Client').as_null_object }

  before { allow(Aws::S3::Client).to receive(:new) { client } }

  context 'when file is found' do
    it 'deletes the file' do
      expect(client).to receive(:delete_object).with(bucket: 'bucket', key: 'dummy.csv')

      s3.delete
    end
  end
end
