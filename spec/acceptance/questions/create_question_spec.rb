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

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    click_on 'Новый вопрос'
    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
