# frozen_string_literal: true
RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
end
