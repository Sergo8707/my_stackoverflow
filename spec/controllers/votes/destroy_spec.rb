# frozen_string_literal: true
require 'rails_helper'

RSpec.describe VotesController, type: :controller do
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
          expect(response).to have_http_status :success
          expect(response).to match_response_schema('vote_serialized')
        end
      end

      context 'not author vote' do
        before { sign_in question.user }

        it 'delete vote' do
          expect { delete :destroy, params: { id: vote.id, format: :json } }.to_not change(Vote, :count)
        end

        it 'render error' do
          delete :destroy, params: { id: vote.id, format: :json }
          expect(response).to have_http_status :forbidden
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
