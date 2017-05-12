# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '#data_csv' do
  context 'when path is not about s3' do
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

  context 'when path is about s3' do
    before do
      stub_const 'Dummy', Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv path: :s3, tmp_dir: local_path }
    end

    it 'reads csv from s3' do
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
end
