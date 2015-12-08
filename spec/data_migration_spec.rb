require 'spec_helper'

describe DataMigration do
  it { expect(DataMigration.new version: '19841023113000').to be_valid }

  it { is_expected.to validate_uniqueness_of :version }
end
