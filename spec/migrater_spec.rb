# frozen_string_literal: true

require 'spec_helper'

describe DataMigrater::Migrator do
  before do
    FileUtils.mkdir_p 'db/migrate'

    allow(Rails).to receive(:root) { '.' }
  end

  after do
    FileUtils.rm_rf 'db'
  end

  let(:connection) { ActiveRecord::Base.connection }

  it 'has a version number' do
    expect(DataMigrater::VERSION).not_to be_nil
  end

  describe '.migrate' do
    let(:data_migration)  { double }
    let(:data_migrations) { [data_migration] }
    let(:insert)          { "insert into data_migrations(version) values('21161023010203')" }
    let(:select)          { 'select version from data_migrations' }
    let(:version)         { -> { connection.select_one(select)['version'] } }

    before { connection.insert insert }

    context 'when has no pending migration' do
      context 'when data migration table does not exists' do
        subject { described_class.new collection }

        let(:data_migration) { double }
        let(:collection)     { double migrations: [data_migration] }

        before do
          allow(DataMigration).to receive(:table_exists?) { false }
        end

        it 'does not executes data migration' do
          expect(data_migration).not_to receive :execute

          subject.migrate
        end
      end

      context 'when data migration table exists' do
        context 'but there is no data migration on collection' do
          subject { described_class.new collection }

          let(:collection) { double migrations: [] }

          it { expect { subject.migrate }.not_to change { version.call } }
        end

        context 'and has data migration on collection' do
          let(:data_migration_2) { double }
          let(:collection)       { double migrations: [data_migration, data_migration_2] }

          it 'executes migration' do
            expect(data_migration).to   receive :execute
            expect(data_migration_2).to receive :execute

            described_class.new(collection).migrate
          end
        end
      end
    end

    context 'when migration throws exception' do
      before do
        allow(data_migration).to receive(:execute).and_raise
      end

      it 'keeps the actual version' do
        begin
          subject.migrate
        rescue
        end

        expect(version.call).to eq '21161023010203'
      end
    end

    context 'when there are migration on db/migrate' do
      let(:collection) { double migrations: [data_migration] }

      context 'pending' do
        let(:next_version)   { version.call.to_i + 1 }
        let(:next_migration) { "#{Rails.root}/db/migrate/#{next_version}_migration.rb" }

        before { FileUtils.touch next_migration }
        after  { FileUtils.rm next_migration }

        it 'does not run the data migrations' do
          expect(data_migration).not_to receive :execute

          described_class.new(collection).migrate
        end
      end

      context 'executed' do
        it 'runs the data migrations' do
          expect(data_migration).to receive :execute

          described_class.new(collection).migrate
        end
      end
    end
  end
end
