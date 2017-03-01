feature 'Create answer', %q{
  In order to offer an answer
  As a user
  I want to be able to write the answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Текст ответа', with: 'My answer text'
    click_on 'Ответить'
    expect(page).to have_content 'Ваш ответ успешно создан.'
    expect(page).to have_content 'My answer text'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user create answer with invalid attributes' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Текст ответа', with: ''
    click_on 'Ответить'
    expect(page).to have_content 'Ошибка при создании ответа'
  end

  scenario 'Non-authenticated user try to creates qiestion' do
    visit question_path(question)
    fill_in 'Текст ответа', with: 'My answer text'
    click_on 'Ответить'
    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end