# frozen_string_literal: true
feature 'User sign out', '
  In order to complete the work of the session
  As a user
  I want to be able to go out and the system
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)
    click_on 'Выход'
    expect(page).to have_content '×Выход из системы выполнен.'
    expect(current_path).to eq root_path
  end

  scenario 'non-authenticated user try to sign out' do
    visit root_path
    expect(page).not_to have_link('Выход')
  end
end
