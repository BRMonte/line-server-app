class LineReaderService
  FILE_PATH = Rails.root.join("storage", "test.txt")

  def self.fetch_line(line_index)
    return nil unless File.exist?(FILE_PATH)

    File.foreach(FILE_PATH).with_index do |line, index|
      return line.strip if index == line_index
    end

    nil
  end
end
