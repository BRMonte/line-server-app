class LineReaderService
  MAX_FILE_SIZE = 7.gigabytes

  def self.fetch_line(line_index)
    raise "File not found" unless TextFile.exists?

    file_size = TextFile.file_size

    if file_size < MAX_FILE_SIZE
      process_line_sequentially(line_index)
    else
      process_line_in_parallel(line_index)
    end
  end

  private

  def self.process_line_sequentially(line_index)
    Rails.logger.debug('*** Method fetch_line entered (Sequential)')

    File.foreach(TextFile::FILE_PATH).with_index do |line, index|
      return line.strip if index == line_index
    end

    Rails.logger.debug('*** Line not found')
    nil
  end

  def self.process_line_in_parallel(line_index)
    Rails.logger.debug('*** Method fetch_line entered (Parallel)')

    chunk_size = (TextFile.total_lines / 4.0).ceil
    jobs = []
    start_index = 0

    4.times do |i|
      jobs << Thread.new do
        start_line = start_index + (i * chunk_size)
        end_line = start_index + ((i + 1) * chunk_size) - 1

        File.foreach(TextFile::FILE_PATH).with_index do |line, index|
          next unless index.between?(start_line, end_line)
          return line.strip if index == line_index
        end
      end
    end

    result = nil
    jobs.each { |job| result = job.value if job.value }

    result
  end
end
