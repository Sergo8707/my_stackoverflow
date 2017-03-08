# frozen_string_literal: true
RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  describe 'PATCH #mark_best' do
    context 'Authenticated user' do
      before { sign_in question.user }

      context 'asker' do
        before { patch :mark_best, params: { id: answer }, format: :js }
        it 'marks best answer' do
          expect(answer.reload).to be_best
        end

        it 'render template best' do
          expect(response).to render_template :mark_best
        end
      end

      context 'not asker' do
        sign_in_user

        it 'marks best answer' do
          patch :mark_best, params: { id: answer }, format: :js
          expect(answer.reload).to_not be_best
        end
      end
    end

    context 'Non-authenticated user' do
      it 'marks best answer' do
        patch :mark_best, params: { id: answer }, format: :js
        expect(answer.reload).to_not be_best
      end
    end
  end
end
