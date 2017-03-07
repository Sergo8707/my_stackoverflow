# frozen_string_literal: true
RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer),
                                  question_id: question, format: :js }
        end.to change(Answer, :count).by(1)
      end

      it 'answer belongs to the user' do
        post :create, params: { answer: attributes_for(:answer),
                                question_id: question, format: :js }
        expect(Answer.last.user).to eq @user
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'dont save new answer' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer),
                                  question_id: question, format: :js }
        end.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end
end
