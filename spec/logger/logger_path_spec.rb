require "spec_helper"

RSpec.describe "#logger_path" do
  context "with :path" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::Logger }
      Dummy.class_eval { data_logger path: "/tmp/custom.log" }
    end

    it "uses the given one" do
      expect(Dummy.new.logger_path).to eq "/tmp/custom.log"
    end
  end

  context "with :dir" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::Logger }
      Dummy.class_eval { data_logger dir: :dir }
    end

    it "uses the given :dir on path" do
      expect(Dummy.new.logger_path).to eq "dir/dummy.log"
    end
  end

  context "with :file" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::Logger }
      Dummy.class_eval { data_logger file: "file.odd" }
    end

    it "uses the given :file on path" do
      expect(Dummy.new.logger_path).to eq "log/file.odd"
    end
  end

  context "with :dir and :file" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::Logger }
      Dummy.class_eval { data_logger dir: :dir, file: "file.odd" }
    end

    it "uses the given :dir and :file as path" do
      expect(Dummy.new.logger_path).to eq "dir/file.odd"
    end
  end

  context "with not :dir nor :file" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::Logger }
      Dummy.class_eval { data_logger }
    end

    it "uses the default :dir and :file as path" do
      expect(Dummy.new.logger_path).to eq "log/dummy.log"
    end
  end

  context "with no callback options method" do
    before do
      stub_const "Dummy", Class.new

      Dummy.class_eval { include DataMigrater::Logger }
    end

    it "uses the default :dir and :file as path" do
      expect(Dummy.new.logger_path).to eq "log/dummy.log"
    end
  end
end
