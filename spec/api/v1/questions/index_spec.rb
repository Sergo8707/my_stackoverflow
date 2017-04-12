# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'
    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge!(options)
    end
  end
end
