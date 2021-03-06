# frozen_string_literal: true
require_relative '../acceptance_helper'
feature 'Answer editing', "
  In order to fix mistake
  As an author of answer
  I'd like ot be able to edit my answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Изменить'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'author sees link to Edit' do
      within '.answers' do
        expect(page).to have_link 'Изменить'
      end
    end

    scenario 'author try to edit answer', js: true do
      click_on 'Изменить'
      updated_text = 'edited answer'
      within '.answers' do
        fill_in 'answer[body]', with: updated_text
        click_on 'Сохранить'
        expect(page).to_not have_content answer.body
        expect(page).to have_content updated_text
        within '.answer-edit' do
          expect(page).to_not have_selector 'textarea'
        end
      end
    end

    scenario "not author try to edit other user's answer" do
      another_user = create(:user)
      another_answer = create(:answer, question: question, user: another_user)
      visit question_path(question)
      within ".answer-#{another_answer.id}" do
        expect(page).to_not have_content 'Изменить'
      end
    end

    context 'try update to answer with invalid attributes' do
      scenario 'body text is too short', js: true do
        answer_text = 'text567'
        within ".answer-#{answer.id}" do
          click_on 'Изменить'
          fill_in 'answer[body]', with: answer_text
          click_on 'Сохранить'
        end
        expect(page).not_to have_content answer_text
        expect(page).to have_content 'Body слишком короткий'
      end

      scenario 'body text is blank', js: true do
        within ".answer-#{answer.id}" do
          click_on 'Изменить'
          fill_in 'answer[body]', with: ''
          click_on 'Сохранить'
        end
        expect(page).to have_content 'Body не может быть пустым!'
      end
    end
  end
end
