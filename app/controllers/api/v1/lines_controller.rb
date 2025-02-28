module Api
  module V1
    class LinesController < ApplicationController
      def index
      end

      def show
        line_index = params[:id].to_i

        unless TextFile.valid_line_index?(line_index)
          Rails.logger.warn { '*** Line index out of range' }

          render json: { error: "Line index out of range" }, status: :unprocessable_entity
          return
        end

        line_content = LineReaderService.fetch_line(line_index)

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
    end
  end
end
