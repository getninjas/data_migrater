require "spec_helper"

class Dummy
  include DataMigrater::CSV

  data_logger path: "dummy.log"

  def log
    logger.info "done!"
  end
end

RSpec.describe Dummy, "#data_logger" do
  subject { Dummy.new }

  context "with a given :path" do
    it "caches the options" do
      expect(described_class.options).to eq(path: "dummy.log")
    end

    it "has the right format" do
      subject.log

      expect(read).to match /\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4}\] INFO Dummy: done!\n/
    end
  end

  def read
    File.readlines(described_class.options[:path]).last
  end
end
