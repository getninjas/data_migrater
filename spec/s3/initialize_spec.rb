# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataMigrater::S3, 'initialize' do
  subject(:s3) { described_class.new 'data-migrater', credentials, 'dummy.csv' }

  before do
    allow(ENV).to receive(:[]).with('AWS_ACCESS_KEY_ID').and_return('AWS_ACCESS_KEY_ID')
    allow(ENV).to receive(:fetch).with('AWS_REGION', 'us-east-1').and_return('AWS_REGION')
    allow(ENV).to receive(:[]).with('AWS_SECRET_ACCESS_KEY').and_return('AWS_SECRET_ACCESS_KEY')
  end

  context 'when credentials is not given' do
    let!(:credentials) { {} }

    let!(:credentials_env) do
      { access_key_id: 'AWS_ACCESS_KEY_ID', region: 'AWS_REGION', secret_access_key: 'AWS_SECRET_ACCESS_KEY' }
    end

    it 'caches default values and uses exported envs' do
      expect(s3.instance_variable_get(:@bucket)).to      eq 'data-migrater'
      expect(s3.instance_variable_get(:@csv_path)).to    eq 'dummy.csv'
      expect(s3.instance_variable_get(:@credentials)).to eq credentials_env
    end

    it 'updates the aws config' do
      expect(::Aws.config).to receive(:update).with credentials_env

      subject
    end
  end

  context 'when credentials is given' do
    let!(:credentials) { { access_key_id: 'access_key_id', region: 'region', secret_access_key: 'secret_access_key' } }

    it 'is used' do
      expect(::Aws.config).to receive(:update).with credentials

      subject
    end
  end
end
