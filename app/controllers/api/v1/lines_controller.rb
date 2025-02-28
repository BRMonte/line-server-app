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
      rescue ClientError => e
        logger.error { "*** #{e}: #{e.message}" }
      end

      private

      def validate_line_index(line_index)
        return if TextFile.valid_line_index?(line_index)

        Rails.logger.warn { '*** Line index out of range' }

        render json: { error: "Line index out of range" }, status: :unprocessable_entity
      end

      def fetch_or_cache_line(line_index)
        cache_key = "line_#{line_index}"

        Rails.cache.fetch(cache_key, expires_in: 1.day) do
          content = LineReaderService.fetch_line(line_index)
          track_cache_key(cache_key) if content.present?
          content
        end
      end

      def track_cache_key(key)
        cached_keys = Rails.cache.fetch("cached_line_keys") { [] }
        cached_keys << key unless cached_keys.include?(key)
        Rails.cache.write("cached_line_keys", cached_keys)
      end
    end
  end
end
