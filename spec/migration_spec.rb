# frozen_string_literal: true

require 'spec_helper'

describe DataMigrater::Migration do
  let(:name)     { 'add_column_to_users_table' }
  let(:path)     { 'db/data_migrate' }
  let(:version)  { '20151205090800' }
  let(:filename) { "#{version}_#{name}" }

  class AddColumnToUsersTable
  end

  before do
    FileUtils.mkdir_p path
    FileUtils.touch "#{path}/#{filename}.rb"
  end

  after do
    FileUtils.rm_rf 'db'
  end

  describe '#execute' do
    subject { described_class.new version, name, filename, path }

    let(:migration) { double.as_null_object }

    before do
      allow(AddColumnToUsersTable).to receive(:new) { migration }
    end

    context 'when migration was already run' do
      before do
        DataMigration.create version: version
      end

      specify { expect(subject.execute).to eq false }

      it 'does not executes' do
        expect(migration).not_to receive :execute

        subject.execute
      end
    end

    context 'when migration was not run before' do
      it 'executes the migration' do
        expect(migration).to receive :execute

        subject.execute
      end

      it 'creates a new data_migrations' do
        subject.execute

        expect(DataMigration.exists?(version: version)).to eq true
      end

      context 'and some error is raised' do
        before do
          allow(migration).to receive(:execute).and_raise RuntimeError
        end

        specify { expect { subject.execute }.to raise_error RuntimeError }

        it 'removes data migration object' do
          begin
            subject.execute
          rescue
            expect(DataMigration.exists?(version: version)).to eq false
          end
        end
      end
    end
  end
end
