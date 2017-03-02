# frozen_string_literal: true
feature 'Delete question', '
  In order to delete wrong question
  As a user
  I want to be able to delete question
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user remove question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Удалить вопрос'
    expect(page).to have_content 'Ваш вопрос был успешно удален.'
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user tries to remove another author question' do
    another_user = create(:user)
    sign_in(another_user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Non-authenticated user tries to remove question' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end
end
