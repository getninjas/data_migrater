require "spec_helper"

RSpec.describe "#options" do
  before do
    stub_const "Dummy", Class.new

    Dummy.class_eval { include DataMigrater::CSV }
    Dummy.class_eval { data_csv dir: "spec/support/csv", chunk_size: 1, key_mapping: { first_name: :first } }
  end

  it "applies the options on csv gem" do
    expect(Dummy.new.csv).to eq [
      [{
        first:     "Washington",
        last_name: "Botelho",
        username:  "wbotelhos",
        age:       32,
        birthday:  "23/10/1984"
      }],

      [{
        first:     "Lucas",
        last_name: "Souza",
        username:  "lucasas"
      }]
    ]
  end
end
