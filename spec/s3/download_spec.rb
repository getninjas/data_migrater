# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataMigrater::S3, '.download' do
  let!(:client)    { double(Aws::S3).as_null_object }
  let!(:file_open) { double(File).as_null_object }
  let!(:processor) { double.as_null_object }
  let!(:temp_file) { double(File).as_null_object }

  subject { described_class.new file: 'dummy.csv' }

  before do
    allow(Aws::S3::Client).to receive(:new) { client }
    allow(File).to receive(:open).with('/tmp/dummy.csv', 'w+').and_yield temp_file
  end

  it 'downloads the csv file' do
    expect(client).to receive(:get_object).with({ bucket: 'data-migrater', key: 'dummy.csv' }, target: temp_file)

    subject.download processor: processor
  end

  it 'process the csv content with given processor' do
    expect(processor).to receive(:process).with temp_file

    subject.download processor: processor
  end
end
