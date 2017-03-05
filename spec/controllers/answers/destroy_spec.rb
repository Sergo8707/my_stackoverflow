RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { sign_in answer.user }

      context 'User is author' do
        it 'delete answer' do
          expect { delete :destroy, params: {id: answer} }.to change(Answer, :count).by(-1)
        end

        it 'redirect to question view' do
          delete :destroy, params: {id: answer}
          expect(response).to redirect_to question
        end
      end

      context 'User is not the author' do
        let!(:another_user) { create(:user) }
        let!(:another_answer) { create(:answer, user: another_user, question: question) }
        render_views

        it 'try delete answer' do
          another_answer
          expect { delete :destroy, params: {id: another_answer} }.to_not change(Answer, :count)
        end

        it 're-renders question view' do
          delete :destroy, params: {id: another_answer}
          expect(response).to render_template 'questions/show'
          expect(response.body).to match another_answer.body
        end
      end
    end

    context 'Non-authenticated user' do
      it 'delete answer' do
        answer
        expect { delete :destroy, params: {id: answer} }.to_not change(Answer, :count)
      end
    end
  end
end