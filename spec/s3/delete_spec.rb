# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataMigrater::S3, '.delete' do
  subject(:s3) { described_class.new options.merge(credentials: {}, tmp_dir: '/tmp') }

  let!(:client)  { double('Aws::S3::Client').as_null_object }
  let!(:options) { { bucket: 'data-migrater', key: 'dummy.csv' } }

  before { allow(Aws::S3::Client).to receive(:new) { client } }

  context 'when file is found' do
    it 'deletes the file' do
      expect(client).to receive(:delete_object).with(options)

      s3.delete
    end
  end
end
