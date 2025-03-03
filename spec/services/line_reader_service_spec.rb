require 'rails_helper'

RSpec.describe LineReaderService, type: :service do
  let(:text_file) { TextFile.instance }
  let(:file_path) { text_file.class::FILE_PATH }

  before do
    allow(text_file).to receive(:exists?).and_return(true)
  end

  describe '.fetch_line' do
    context 'when the file exists and is small' do
      it 'returns the correct line' do
        allow(text_file).to receive(:file_size).and_return(1.gigabyte)

        allow(File).to receive(:foreach).with(file_path).and_return(["Line 0\n", "Line 1\n"])

        expect(described_class.fetch_line(1)).to eq("Line 1")
      end
    end

    context 'when the file does not exist' do
      it 'raises an error' do
        allow(text_file).to receive(:exists?).and_return(false)
        expect { described_class.fetch_line(1) }.to raise_error("File not found")
      end
    end
  end
end
