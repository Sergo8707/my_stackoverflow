feature 'User sign out', %q{
  In order to complete the work of the session
  As a user
  I want to be able to go out and the system
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)
    click_on 'Выход'
    expect(page).to have_content 'Вход Регистрация Выход из системы выполнен. Новый вопрос'
    expect(current_path).to eq root_path
  end
end