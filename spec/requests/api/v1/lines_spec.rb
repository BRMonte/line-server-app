require 'rails_helper'

RSpec.describe 'Api::V1::Lines', type: :request do
  let(:valid_line_index) { 1 }
  let(:invalid_line_index) { 1000 }
  let(:line_content) { "This is line 1" }

  before do
    allow(TextFile.instance).to receive(:valid_line_index?).and_return(false)
    allow(TextFile.instance).to receive(:valid_line_index?).with(valid_line_index).and_return(true)
    allow(LineCaching).to receive(:fetch_or_cache).and_return(line_content)
  end

  describe 'GET /api/v1/lines/:id' do
    context 'with a valid line index' do
      before do
        get "/api/v1/lines/#{valid_line_index}"
      end

      it 'returns HTTP status OK' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct line content' do
        expect(JSON.parse(response.body)).to eq({
          'line_index' => valid_line_index,
          'content' => line_content
        })
      end
    end

    context 'with an invalid line index' do
      before do
        get "/api/v1/lines/#{invalid_line_index}"
      end

      it 'returns HTTP status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Line index out of range'
        })
      end
    end

    context 'when the line is not found' do
      before do
        allow(LineCaching).to receive(:fetch_or_cache).and_return(nil)
        get "/api/v1/lines/#{valid_line_index}"
      end

      it 'returns HTTP status not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Line not found'
        })
      end
    end

    context 'when an exception is raised' do
      before do
        allow(LineCaching).to receive(:fetch_or_cache).and_raise(StandardError.new('Something went wrong'))
        get "/api/v1/lines/#{valid_line_index}"
      end

      it 'returns HTTP status internal_server_error' do
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Internal Server Error'
        })
      end
    end
  end
end
