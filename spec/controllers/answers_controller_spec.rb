# frozen_string_literal: true
require 'rails_helper'

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

  describe 'POST #create' do
    before { answer }
    context 'with valid attributes' do
      it 'save new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer),
                                  question_id: answer.question_id }
        end.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: answer.question_id }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      it 'dont save new answer' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer),
                                  question_id: answer.question_id }
        end.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: answer.question_id }
        expect(response).to render_template :new
      end
    end
  end
end
