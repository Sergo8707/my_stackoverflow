require_relative '../acceptance_helper'
# frozen_string_literal: true
feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Новый вопрос'
    fill_in 'Заголовок', with: 'Text2 question'
    fill_in 'Ваш вопрос', with: 'text2 text'
    click_on 'Создать'

    expect(page).to have_content 'Ваш вопрос успешно создан.'
  end
  context 'mulitple sessions' do
    scenario "question appears on another user's page", js: true do
      title = 'Новый вопрос'
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Новый вопрос'
        fill_in 'Заголовок', with: title
        fill_in 'Ваш вопрос', with: 'text question'
        click_on 'Создать'

        expect(page).to have_content '×Ваш вопрос успешно создан.'
        expect(page).to have_content title
      end

      Capybara.using_session('guest') do
        expect(page).to have_content title
      end
    end
  end
  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'
  end
end
