# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '#converters' do
  before do
    stub_const 'Dummy', Class.new

    Dummy.class_eval { include DataMigrater::CSV }
    Dummy.class_eval { data_csv dir: 'spec/support/csv', value_converters: { birthday: DateConverter } }
  end

  class DateConverter
    def self.convert(value)
      Date.strptime value, '%d/%m/%y'
    end
  end

  it 'returns an array of hash' do
    expect(Dummy.new.csv).to eq [
      {
        first_name: 'Washington',
        last_name: 'Botelho',
        username: 'wbotelhos',
        age: 32,
        birthday: Date.strptime('23/10/1984', '%d/%m/%y')
      },

      {
        first_name: 'Lucas',
        last_name: 'Souza',
        username: 'lucasas'
      }
    ]
  end
end
