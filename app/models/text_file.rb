class TextFile
  FILE_PATH = Rails.root.join("storage", "test.txt")

  def self.total_lines
    File.readlines(FILE_PATH).size
  end

  def self.valid_line_index?(line_index)
    line_index >= 0 && line_index < total_lines
  end
end
