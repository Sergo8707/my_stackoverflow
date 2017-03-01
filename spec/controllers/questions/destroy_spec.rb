# frozen_string_literal: true
RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  context 'Authenticated user' do
    before { sign_in question.user }

    context 'User is author' do
      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User is not the author' do
      let(:another_user) { create(:user) }
      let(:another_question) { create(:question, user: another_user) }
      render_views

      it 'delete try question' do
        another_question
        expect { delete :destroy, params: { id: another_question } }.to_not change(Question, :count)
      end

      it 're-renders question view' do
        delete :destroy, params: { id: another_question }
        expect(response).to render_template :show
        expect(response.body).to match another_question.body
        expect(response.body).to match another_question.title
      end
    end
  end

  context 'Non-authenticated user' do
    it 'delete question' do
      question = create(:question)
      expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
    end
  end
end
