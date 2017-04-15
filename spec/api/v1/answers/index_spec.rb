# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Answers API' do
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let(:answer) { answers.last }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body best created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge!(options)
    end
  end
end
