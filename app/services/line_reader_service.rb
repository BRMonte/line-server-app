class LineReaderService
  FILE_PATH = Rails.root.join("storage", "test.txt")
  CACHE_EXPIRY = 1.day

  def self.fetch_line(line_index)
    Rails.cache.fetch("line_#{line_index}", expires_in: CACHE_EXPIRY) do
      Rails.logger.debug('*** Method fetch_line entered')
      return nil unless File.exist?(FILE_PATH)

      File.foreach(FILE_PATH).with_index do |line, index|
        if index == line_index
          Rails.logger.debug('*** Line found')
          return line.strip
        end
      end

      Rails.logger.debug('*** Line not found')
      nil
    end
  end
end
