module LineCaching
  def self.fetch_or_cache(line_index, line_reader_service: LineReaderService)
    cache_key = "line_#{line_index}"

    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      content = line_reader_service.fetch_line(line_index)
      Rails.logger.debug("*** Caching line: #{cache_key} -> #{content.inspect}") if content.present?
      content
    end
  end
end
