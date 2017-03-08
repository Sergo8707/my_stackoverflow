# frozen_string_literal: true
require_relative '../acceptance_helper'

feature 'Create answer', '
  In order to offer an answer
  As a user
  I want to be able to write the answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Текст ответа', with: 'My answer text'
    click_on 'Ответить'
    within '.answers' do
      expect(page).to have_content 'My answer text'
    end
    expect(current_path).to eq question_path(question)
  end

  describe 'Authenticated user create answer with invalid attributes' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'body text is too short', js: true do
      fill_in 'Текст ответа', with: 'text567'
      click_on 'Ответить'
      expect(page).not_to have_content 'text567'
      expect(page).to have_content 'Body слишком короткий'
    end

    scenario 'body text is blank', js: true do
      fill_in 'Текст ответа', with: ''
      click_on 'Ответить'
      expect(page).to have_content "Body не может быть пустым!"
    end
  end

  scenario 'Non-authenticated user try to creates qiestion', js: true do
    visit question_path(question)
    expect(page).not_to have_selector('#answer_body')
  end
end
