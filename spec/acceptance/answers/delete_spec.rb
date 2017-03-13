require_relative '../acceptance_helper'
# frozen_string_literal: true
feature 'Delete answer', '
  In order to remove the incorrect answer
  As an authenticated user
  I want to be able to delete the answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user try delete answer', js: true do
    sign_in(user)
    answer = create(:answer, user: user, question: question)
    visit question_path(question)
    click_on 'Удалить ответ'
    expect(page).to_not have_content answer.body
    expect(page).to have_content 'Ваш ответ был успешно удален.'
  end

  scenario 'Authenticated user tries to remove another author answer' do
    answer = create(:answer, user: user, question: question)
    another_user = create(:user)
    sign_in(another_user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Non-authenticated user tries to remove answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end
end
