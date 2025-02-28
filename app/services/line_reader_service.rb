class LineReaderService
  SIZE_LIMIT_FOR = {
    sequential_processing: 3.gigabytes,
    parallel_processing: 10.gigabytes,
  }
  SEQUENTIAL_PROCESSING_FILE_SIZE = 3.gigabytes
  PARALLEL_PROCESSING_FILE_SIZE   = 10.gigabytes

  @text_file = TextFile.instance

  def self.fetch_line(line_index)
    raise "File not found" unless @text_file.exists?

    file_size = @text_file.file_size

    if file_size <= SIZE_LIMIT_FOR[:sequential_processing]
      process_sequentially(line_index)
    elsif file_size <= SIZE_LIMIT_FOR[:parallel_processing]
      process_in_parallel(line_index)
    end
  end

  private

  def self.process_sequentially(line_index)
    Rails.logger.debug('*** Processing sequentially')

    File.foreach(@text_file.class::FILE_PATH).with_index do |line, index|
      return line.strip if index == line_index
    end

    Rails.logger.debug('*** Line not found')
    nil
  end

  def self.process_in_parallel(line_index)
    Rails.logger.debug('*** Processing in parallel')

    start_index = 0
    chunk_size  = (@text_file.total_lines / 4.0).ceil
    jobs        = []

    4.times do |i|
      jobs << Thread.new do
        start_line = start_index + (i * chunk_size)
        end_line = start_index + ((i + 1) * chunk_size) - 1

        File.foreach(@text_file.class::FILE_PATH).with_index do |line, index|
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
