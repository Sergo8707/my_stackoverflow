# frozen_string_literal: true
require_relative '../acceptance_helper'

feature 'Question editing', "
  In order to fix mistake
  As an author of question
  I'd like ot be able to edit my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    context 'author' do
      scenario 'sees link to Edit' do
        expect(page).to have_link 'Изменить вопрос'
      end

      scenario 'try to edit question', js: true do
        click_on 'Изменить вопрос'
        updated_title = 'updated title question'
        updated_text = 'updated question'
        within '.question' do
          fill_in 'question[title]', with: updated_title
          fill_in 'question[body]', with: updated_text
          click_on 'Сохранить'
          expect(page).to_not have_content question.title
          expect(page).to have_content updated_title
          expect(page).to_not have_content question.body
          expect(page).to have_content updated_text
          within '.question-edit' do
            expect(page).to_not have_selector 'textarea'
          end
        end
      end

      context 'try edit with invalid attributes' do
        before { click_on 'Изменить вопрос' }

        context 'attributes is to short' do
          let(:short_text) { 'text567' }

          scenario 'title', js: true do
            fill_in 'question[title]', with: short_text
            click_on 'Сохранить'
            expect(page).not_to have_content short_text
            expect(page).to have_content 'Title слишком короткий'
          end

          scenario 'body text', js: true do
            fill_in 'question[body]', with: short_text
            click_on 'Сохранить'
            expect(page).not_to have_content short_text
            expect(page).to have_content 'Body слишком короткий'
          end
        end

        context 'attributes blank' do
          scenario 'title', js: true do
            fill_in 'question[title]', with: ''
            click_on 'Сохранить'
            expect(page).to have_content 'Title не может быть пустым!'
          end

          scenario 'body', js: true do
            fill_in 'question[body]', with: ''
            click_on 'Сохранить'
            expect(page).to have_content 'Body не может быть пустым!'
          end
        end
      end
    end

    scenario 'not author try edit' do
      another_question = create(:question)
      visit question_path(another_question)
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
end
