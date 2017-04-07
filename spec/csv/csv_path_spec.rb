require "spec_helper"

RSpec.describe "#csv_path" do
  context "with :path" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv path: "/tmp/custom.csv" }
    end

    it "uses the given one" do
      expect(Dummy.new.csv_path).to eq "/tmp/custom.csv"
    end
  end

  context "with :dir" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv dir: :dir }
    end

    it "uses the given :dir on path" do
      expect(Dummy.new.csv_path).to eq "dir/dummy.csv"
    end
  end

  context "with :file" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv file: "file.odd" }
    end

    it "uses the given :file on path" do
      expect(Dummy.new.csv_path).to eq "data_migrater/support/csv/file.odd"
    end
  end

  context "with :dir and :file" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv dir: :dir, file: "file.odd" }
    end

    it "uses the given :dir and :file as path" do
      expect(Dummy.new.csv_path).to eq "dir/file.odd"
    end
  end

  context "with not :dir nor :file" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::CSV }
      Dummy.class_eval { data_csv }
    end

    it "uses the default :dir and :file as path" do
      expect(Dummy.new.csv_path).to eq "data_migrater/support/csv/dummy.csv"
    end
  end
end
