# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '#csv_delete' do
  let!(:s3) { instance_double 'DataMigrater::S3' }

  before do
    stub_const 'Dummy', Class.new

    Dummy.class_eval { include DataMigrater::CSV }
    Dummy.class_eval { data_csv path: :s3 }

    allow(DataMigrater::S3).to receive(:new).with(
      bucket:      'data-migrater',
      credentials: {},
      key:         'dummy.csv',
      tmp_dir:     '/tmp'
    ).and_return s3
  end

  it 'delegates delete to s3 object' do
    expect(s3).to receive(:delete)

    Dummy.new.csv_delete
  end
end
