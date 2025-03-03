module Api
  module V1
    class LinesController < ApplicationController
      def index; end

      def show
        line_index = params[:id].to_i

        validate_line_index(line_index)

        line_content = fetch_or_cache_line(line_index)

        if line_content.present?
          Rails.logger.info("*** Line content found -> #{line_content}")

          render json: { line_index: line_index, content: line_content }, status: :ok
        else
          Rails.logger.warn { "*** Request returned #{response.code}, #{response.body}" }

          render json: { error: "Line not found" }, status: :not_found
        end
      rescue => e
        logger.error { "*** #{e}: #{e.message}" }
        render json: { error: "Internal Server Error" }, status: :internal_server_error
      end

      private

      def validate_line_index(line_index)
        return if TextFile.instance.valid_line_index?(line_index)

        Rails.logger.warn { '*** Line index out of range' }

        render json: { error: "Line index out of range" }, status: :unprocessable_entity
      end

      def fetch_or_cache_line(line_index)
        cache_key = "line_#{line_index}"

        Rails.cache.fetch(cache_key, expires_in: 1.day) do
          content = LineReaderService.fetch_line(line_index)
          if content.present?
            track_cache_key(cache_key)
            Rails.logger.debug("*** Caching line: #{cache_key} -> #{content.inspect}")
          end
          content
        end
      end

      def track_cache_key(key)
        cached_keys = Rails.cache.read("cached_line_keys") || []
        cached_keys |= [key]

        Rails.cache.write("cached_line_keys", cached_keys)

        Rails.logger.debug("*** Cached Keys (AFTER SAVE) -> #{Rails.cache.read("cached_line_keys").inspect}")
      end
    end
  end
end
