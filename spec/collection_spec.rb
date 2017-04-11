# frozen_string_literal: true

require 'spec_helper'

describe DataMigrater::Collection do
  let(:path) { 'db/data_migrate' }

  before do
    FileUtils.mkdir_p path

    allow(Rails).to receive(:root) { '.' }
  end

  after { FileUtils.rm_rf 'db' }

  describe '.migrations' do
    subject { described_class.new path }

    let!(:file_1) { '20151205090800_add_column' }
    let!(:file_2) { '20151205090801_rename_column' }
    let!(:file_3) { 'invalid_20151205090802_remove_column' }

    before do
      FileUtils.touch "#{path}/#{file_1}.rb"
      FileUtils.touch "#{path}/#{file_2}.rb"
      FileUtils.touch "#{path}/#{file_3}.rb"
    end

    it 'returns valid migrations' do
      expect(subject.migrations.size).to eq 2

      expect(subject.migrations.first.name).to    eq 'add_column'
      expect(subject.migrations.first.version).to eq 20151205090800

      expect(subject.migrations.last.name).to    eq 'rename_column'
      expect(subject.migrations.last.version).to eq 20151205090801
    end
  end
end
