# frozen_string_literal: true
feature 'User sign up', '
  In order to be able to ask questions
  As a guest
  I want to be able to register in the system
' do

  given!(:registration_email) { 'reguser@test.com' }
  scenario 'Guest user try to sign up' do
    visit root_path
    click_link 'Регистрация'
    fill_in 'Email', with: registration_email
    fill_in 'Пароль', with: '123456'
    fill_in 'Подтвердите пароль', with: '123456'
    click_button 'Зарегистрироваться'
    expect(page).to have_content '×В течение нескольких минут вы получите письмо с инструкциями по подтверждению вашей учётной записи.'

    open_email(registration_email)
    current_email.click_link 'Confirm my account'
    expect(page).to have_content '×Ваша учётная запись успешно подтверждена.'
    expect(current_path).to eq new_user_session_path
  end
end
