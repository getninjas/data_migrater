# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataMigrater::S3, 'initialize' do
  before do
    allow(ENV).to receive(:[]).with('AWS_ACCESS_KEY_ID') { 'AWS_ACCESS_KEY_ID' }
    allow(ENV).to receive(:[]).with('AWS_REGION') { 'AWS_REGION' }
    allow(ENV).to receive(:[]).with('AWS_SECRET_ACCESS_KEY') { 'AWS_SECRET_ACCESS_KEY' }
  end

  context 'when only mandatory params is given' do
    subject { described_class.new bucket: 'data-migrater', file: 'dummy.csv', tmp_dir: '/tmp' }

    it 'caches default values and uses exported envs' do
      expect(subject.instance_variable_get(:@bucket)).to  eq 'data-migrater'
      expect(subject.instance_variable_get(:@file)).to    eq 'dummy.csv'
      expect(subject.instance_variable_get(:@tmp_dir)).to eq '/tmp'

      expect(subject.instance_variable_get(:@credentials)).to eq(
        access_key_id:     'AWS_ACCESS_KEY_ID',
        region:            'AWS_REGION',
        secret_access_key: 'AWS_SECRET_ACCESS_KEY'
      )
    end

    it 'updates the aws config' do
      expect(::Aws.config).to receive(:update).with(
        access_key_id:     'AWS_ACCESS_KEY_ID',
        region:            'AWS_REGION',
        secret_access_key: 'AWS_SECRET_ACCESS_KEY'
      )

      subject
    end
  end

  context 'when some credential is given' do
    subject do
      described_class.new(
        bucket:  'data-migrater',
        file:    'dummy.csv',
        tmp_dir: '/tmp',

        credentials: {
          access_key_id:     'access_key_id',
          region:            'region',
          secret_access_key: 'secret_access_key'
        }
      )
    end

    it 'is used' do
      expect(::Aws.config).to receive(:update).with(
        access_key_id:     'AWS_ACCESS_KEY_ID',
        region:            'us-east-1',
        secret_access_key: 'AWS_SECRET_ACCESS_KEY'
      )

      subject
    end
  end
end
