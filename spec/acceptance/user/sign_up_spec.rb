# frozen_string_literal: true
feature 'User sign up', '
  In order to be able to ask questions
  As a guest
  I want to be able to register in the system
' do

  scenario 'Guest user try to sign up' do
    visit root_path
    click_link 'Регистрация'
    fill_in 'Email', with: 'reguser@test.com'
    fill_in 'Пароль', with: '123456'
    fill_in 'Подтвердите пароль', with: '123456'
    click_button 'Зарегистрироваться'
    expect(page).to have_content 'Добро пожаловать! Вы успешно зарегистрировались.'
    expect(current_path).to eq root_path
  end
end
