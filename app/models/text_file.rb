class TextFile
  FILE_PATH = Rails.root.join("storage", "test.txt").freeze

  def self.total_lines
    @total_lines ||= count_lines
  end

  private

  def self.count_lines
    return 0 unless File.exist?(FILE_PATH)

    File.foreach(FILE_PATH).count
  end
end
