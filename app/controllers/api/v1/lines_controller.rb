module Api
  module V1
    class LinesController < ApplicationController
      def index
      end

      def show
        line_index = params[:line_index].to_i

        if line_index.negative? || line_index >= TextFile.total_lines
          render json: { error: "Line index out of range" }, status: :unprocessable_entity
          return
        end

        line_content = LineReaderService.fetch_line(line_index)

        if line_content.present?
          render json: { line_index: line_index, content: line_content }, status: :ok
        else
          render json: { error: "Line not found" }, status: :not_found
        end
      end
    end
  end
end
