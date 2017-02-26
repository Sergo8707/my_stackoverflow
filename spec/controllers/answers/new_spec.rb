RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  describe 'GET #new' do
    before { get :new, params: { question_id: answer.question_id } }

    it 'Assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end
end
