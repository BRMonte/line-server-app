module Api
  module V1
    class LinesController < ApplicationController
      include LineCaching

      def index; end

      def show
        line_index = line_params[:id].to_i

        unless TextFile.instance.valid_line_index?(line_index)
          Rails.logger.warn('*** Line index out of range')
          return render json: { error: "Line index out of range" }, status: :unprocessable_entity
        end

        line_content = LineCaching.fetch_or_cache(line_index, line_reader_service: LineReaderService)

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
      def line_params
        params.permit(:id)
      end
    end
  end
end
