# frozen_string_literal: true

require 'spec_helper'

describe DataMigration do
  let(:version) { '19841023113000' }

  it { expect(described_class.new(version: version)).to be_valid }

  it 'validates uniqueness' do
    described_class.create! version: version

    expect do
      described_class.create! version: version
    end.to raise_error ActiveRecord::RecordInvalid
  end
end
