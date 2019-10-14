# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '#data_logger' do
  context 'with :path' do
    subject { Dummy.new }

    before do
      stub_const 'Dummy', Class.new

      Dummy.class_eval { include DataMigrater::Logger }
      Dummy.class_eval { data_logger path: 'custom.log' }
    end

    it 'logs on the given path file with right content' do
      subject.logger.info 'done!'

      result = /\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} (-|\+)\d{4}\] INFO Dummy: done!\n/

      expect(File.readlines('custom.log').last).to match result
    end
  end

  context 'with no :path' do
    subject { Dummy.new }

    before do
      stub_const 'Dummy', Class.new

      Dummy.class_eval { include DataMigrater::Logger }
      Dummy.class_eval { data_logger }
    end

    it 'logs on log folder with class name with right content' do
      subject.logger.info 'done!'

      result = /\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} (-|\+)\d{4}\] INFO Dummy: done!\n/

      expect(File.readlines('log/dummy.log').last).to match result
    end
  end

  context 'with no :data_logger' do
    subject { Dummy.new }

    before do
      stub_const 'Dummy', Class.new

      Dummy.class_eval { include DataMigrater::Logger }
    end

    it 'logs on log folder with class name with right content' do
      subject.logger.info 'done!'

      result = /\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} (-|\+)\d{4}\] INFO Dummy: done!\n/

      expect(File.readlines('log/dummy.log').last).to match result
    end
  end
end
