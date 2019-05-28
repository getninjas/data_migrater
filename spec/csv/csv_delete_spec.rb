# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '#csv_delete' do
  context 'when provider is s3' do
    let!(:s3) { instance_double 'DataMigrater::S3' }

    before do
      stub_const 'Dummy', Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv provider: :s3 }

      allow(DataMigrater::S3).to receive(:new)
        .with('data-migrater', {}, 'db/data_migrate/support/csv/dummy.csv').and_return s3
    end

    it 'delegates delete to s3 object' do
      expect(s3).to receive(:delete)

      Dummy.new.csv_delete
    end
  end

  context 'when has no provider' do
    before do
      stub_const 'Dummy', Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv }
    end

    it 'does not delegates delete to s3 object' do
      expect(DataMigrater::S3).not_to receive(:new)

      Dummy.new.csv_delete
    end
  end
end
