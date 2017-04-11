# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Answers API' do
  let(:access_token) { create(:access_token) }
  describe 'POST #create' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          expect(response).to be_created
        end

        it 'saves the new answer in the database' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }.to change(Answer, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'does not save the answer' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token } }.not_to change(Answer, :count)
        end
      end
    end
    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
