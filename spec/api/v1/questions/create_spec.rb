# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  it_behaves_like 'API Authenticable'

  describe 'POST #create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', params: { question: attributes_for(:question), format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: 'invalid_token' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token }
          expect(response).to be_created
        end

        it 'saves the new question in the database' do
          expect { post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'does not save the question' do
          expect { post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token } }.not_to change(Question, :count)
        end
      end
    end
  end
  def do_request(options = {})
    post '/api/v1/questions', params: { format: :json }.merge(options)
  end
end
