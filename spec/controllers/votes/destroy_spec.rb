# frozen_string_literal: true
require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:question) { create(:question) }
  let!(:vote_params) { { question_id: question, rating: 'up', format: :json } }

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:vote) { create(:vote, votable: question, user: user) }

    context 'Authenticated user' do
      before { sign_in vote.user }
      context 'author vote' do
        it 'delete vote' do
          expect { delete :destroy, params: { id: vote.id, format: :json } }.to change(Vote, :count).by(-1)
        end

        it 'render success' do
          delete :destroy, params: { id: vote.id, format: :json }
          question.reload
          data = JSON.parse(response.body)
          expect(response).to have_http_status :success

          expect(data['id']).to eq vote.id
          expect(data['votable_rating']).to eq question.rating
          expect(data['votable_type']).to eq question.class.name.underscore
          expect(data['votable_id']).to eq question.id
          expect(data['action']).to eq 'delete'
          expect(data['message']).to eq 'Your vote removed!'
        end
      end

      context 'not author vote' do
        before { sign_in question.user }

        it 'delete vote' do
          expect { delete :destroy, params: { id: vote.id, format: :json } }.to_not change(Vote, :count)
        end

        it 'render error' do
          delete :destroy, params: { id: vote.id, format: :json }
          data = JSON.parse(response.body)
          expect(response).to have_http_status :forbidden
          expect(data['error']).to eq 'Error remove'
          expect(data['error_message']).to eq 'You can not remove an vote!'
        end
      end
    end

    context 'Non-authenticated user' do
      it 'delete vote' do
        expect { delete :destroy, params: { id: vote.id, format: :json } }.to_not change(Vote, :count)
      end
    end
  end
end
