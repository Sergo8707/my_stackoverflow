# frozen_string_literal: true
require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:question) { create(:question) }
  let!(:vote_params) { { question_id: question, rating: 'up', format: :json } }

  describe 'POST #create' do
    context 'Authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new vote in the database' do
          expect { post :create, params: vote_params }.to change(question.votes, :count).by(1)
        end

        it 'render success' do
          post :create, params: vote_params
          question.reload
          data = JSON.parse(response.body)
          expect(response).to have_http_status :success

          expect(data['id']).to eq assigns(:vote).id
          expect(data['votable_rating']).to eq question.rating
          expect(data['votable_type']).to eq question.class.name.underscore
          expect(data['votable_id']).to eq question.id
          expect(data['action']).to eq 'create'
          expect(data['message']).to eq 'Your vote has been accepted!'
        end
      end

      context 'double voting' do
        before { create(:vote, votable: question, user: @user) }

        it 'tries vote again' do
          expect { post :create, params: vote_params }.to_not change(question.votes, :count)
        end
      end

      context 'with invalid attributes' do
        let(:rating_missing) { { question_id: question, format: :json } }
        let(:invalid_rating) { { question_id: question, rating: 'something', format: :json } }

        context 'save vote with a negative evaluation' do
          it 'rating missing' do
            expect { post :create, params: rating_missing }.to change(question.votes, :count).by(1)
            expect(question.rating).to eq(-1)
          end

          it 'invalid rating' do
            expect { post :create, params: invalid_rating }.to change(question.votes, :count).by(1)
            expect(question.rating).to eq(-1)
          end
        end
      end

      context 'User is author votable' do
        before { sign_in question.user }

        it 'vote not stored in the database' do
          expect { post :create, params: vote_params }.to_not change(Vote, :count)
        end

        it 'render error' do
          post :create, params: vote_params
          data = JSON.parse(response.body)
          expect(response).to have_http_status :forbidden
          expect(data['error']).to eq 'Error save'
          expect(data['error_message']).to eq 'You can not vote'
        end
      end
    end

    context 'Non-authenticated user' do
      it 'tries vote' do
        expect do
          post :create, params: vote_params
        end.to_not change(Vote, :count)
      end
    end
  end
end