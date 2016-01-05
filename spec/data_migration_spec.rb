require 'spec_helper'

describe DataMigration do
  let(:version) { '19841023113000' }

  it { expect(DataMigration.new version: version).to be_valid }

  it 'validates uniqueness' do
    DataMigration.create! version: version

    expect {
      DataMigration.create! version: version
    }.to raise_error ActiveRecord::RecordInvalid
  end
end
