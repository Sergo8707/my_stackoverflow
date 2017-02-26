RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'DELETE #destroy' do
    sign_in_user
    before { question }

    it 'deletes question' do
      expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end
  end
end
