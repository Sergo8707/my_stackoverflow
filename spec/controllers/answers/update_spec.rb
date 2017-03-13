# frozen_string_literal: true
RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { sign_in answer.user }

      context 'with valid attributes' do
        it 'assings the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          updated_body = 'new updated body'
          patch :update, params: { id: answer, answer: { body: updated_body }, format: :js }
          answer.reload
          expect(answer.body).to eq updated_body
        end

        it 'render update template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:invalid_body) { 'short' }
        before do
          patch :update, params: { id: answer, answer: { body: invalid_body }, format: :js }
        end

        it 'does not update the answer' do
          answer.reload
          expect(answer.body).to_not eq invalid_body
        end

        it 'render update template' do
          expect(response).to render_template :update
        end
      end

      context 'User is not author' do
        let!(:another_user) { create(:user) }
        let!(:another_answer) { create(:answer, user: another_user, question: question) }

        it 'try update answer' do
          updated_body = 'text updated others'
          patch :update, params: { id: another_answer, answer: { body: updated_body }, format: :js }
          expect(another_answer.body).to_not eq updated_body
        end
      end
    end

    context 'Non-authenticated user' do
      it 'update answer' do
        updated_body = 'updated body'
        patch :update, params: { id: answer, answer: { body: updated_body }, format: :js }
        answer.reload
        expect(answer.body).to_not eq updated_body
      end
    end
  end
end
