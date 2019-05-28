# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '#data_csv' do
  context 'when has no provider' do
    before do
      stub_const 'Dummy', Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv dir: 'spec/support/csv' }
    end

    it 'returns an array of hash' do
      expect(Dummy.new.csv).to eq [
        {
          first_name: 'Washington',
          last_name:  'Botelho',
          username:   'wbotelhos',
          age:        32,
          birthday:   '23/10/1984'
        },

        {
          first_name: 'Lucas',
          last_name:  'Souza',
          username:   'lucasas'
        }
      ]
    end
  end

  context 'when provider is s3' do
    before do
      stub_const 'Dummy', Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv provider: :s3 }

      allow(DataMigrater::S3).to receive(:new)
        .with('data-migrater', {}, 'db/data_migrate/support/csv/dummy.csv').and_return double(download: true)

      allow(File).to receive(:exist?).and_return true
    end

    it 'reads csv from s3' do
      expect(::SmarterCSV).to receive(:process).with('db/data_migrate/support/csv/dummy.csv', {})

      Dummy.new.csv
    end
  end

  context 'when file does not exist locally' do
    before do
      stub_const 'Dummy', Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv dir: 'missing/path' }
    end

    it 'does not process' do
      expect(::SmarterCSV).not_to receive(:process)

      Dummy.new.csv
    end

    it 'returns an empty array' do
      expect(Dummy.new.csv).to eq []
    end
  end
end
