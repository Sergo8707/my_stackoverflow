# frozen_string_literal: true
RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { sign_in question.user }

      context 'author' do
        context 'valid attributes' do
          it 'assigns the requested question to @question' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(assigns(:question)).to eq question
          end

          it 'change question attributes' do
            patch :update, params: { id: question, question: { title: 'updated title', body: 'updated body' }, format: :js }
            question.reload
            expect(question.title).to eq 'updated title'
            expect(question.body).to eq 'updated body'
          end

          it 'render update template' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'invalid attributes' do
          let(:expetced_data) { { title: 'premier Title', body: 'premier Body' } }
          let(:question) { create(:question, title: expetced_data[:title], body: expetced_data[:body]) }

          before do
            patch :update, params: { id: question, question: { title: 'updated title', body: nil }, format: :js }
          end

          it 'does not update question' do
            question.reload
            expect(question.title).to eq expetced_data[:title]
            expect(question.body).to eq expetced_data[:body]
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end
      end

      context 'not author' do
        let(:another_user) { create(:user) }
        let(:another_question) { create(:question, user: another_user) }

        it 'try update question' do
          updated_title = 'updated title'
          updated_text = 'updated text'
          patch :update, params: { id: another_question, question: { title: updated_title, body: updated_text }, format: :js }
          expect(another_question.title).to_not eq updated_title
          expect(another_question.body).to_not eq updated_text
        end
      end
    end

    context 'Non-authenticated user' do
      it 'try update question' do
        updated_title = 'updated title'
        updated_text = 'updated text'
        patch :update, params: { id: question, question: { title: updated_title, body: updated_text }, format: :js }
        expect(question.title).to_not eq updated_title
        expect(question.body).to_not eq updated_text
      end
    end
  end
end
