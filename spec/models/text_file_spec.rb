require 'rails_helper'

RSpec.describe TextFile, type: :model do
  let(:text_file) { TextFile.instance }

  describe '#file_size' do
    it 'returns the file size in gigabytes' do
      allow(File).to receive(:size).with(TextFile::FILE_PATH).and_return(2_147_483_648)
      expect(text_file.file_size).to eq(2.0)
    end
  end

  describe '#total_lines' do
    it 'returns the total number of lines in the file' do
      allow(File).to receive(:readlines).with(TextFile::FILE_PATH).and_return(["line 1", "line 2", "line 3"])
      expect(text_file.total_lines).to eq(3)
    end
  end

  describe '#valid_line_index?' do
    it 'returns true if the line index is valid' do
      allow(text_file).to receive(:total_lines).and_return(5)
      expect(text_file.valid_line_index?(3)).to be_truthy
    end

    it 'returns false if the line index is invalid' do
      allow(text_file).to receive(:total_lines).and_return(5)
      expect(text_file.valid_line_index?(6)).to be_falsey
    end

    it 'returns false if the line index is not an integer' do
      expect(text_file.valid_line_index?('invalid')).to be_falsey
    end
  end

  describe '#exists?' do
    it 'returns true if the file exists' do
      allow(File).to receive(:exist?).with(TextFile::FILE_PATH).and_return(true)
      expect(text_file.exists?).to be_truthy
    end

    it 'returns false if the file does not exist' do
      allow(File).to receive(:exist?).with(TextFile::FILE_PATH).and_return(false)
      expect(text_file.exists?).to be_falsey
    end
  end
end
