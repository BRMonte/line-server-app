class TextFile
  FILE_PATH = Rails.root.join("storage", "test.txt")

  def self.file_size
    size_in_bytes = File.size(FILE_PATH)
    size_in_gigabytes = size_in_bytes / 1073741824.0
    size_in_gigabytes.round(2)
  end

  def self.total_lines
    File.readlines(FILE_PATH).size
  end

  def self.valid_line_index?(line_index)
    return false unless line_index.is_a?(Integer)
    line_index >= 0 && line_index < total_lines
  end

  def self.exists?
    File.exist?(FILE_PATH)
  end
end
