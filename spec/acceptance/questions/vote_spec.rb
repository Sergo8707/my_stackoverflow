# frozen_string_literal: true
require_relative '../acceptance_helper'

feature 'Vote questions', '
  In order to be able to vote "yes"/"against" question
  As an authenticated user
  I want to be able to vote for question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    context 'Not author question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'see links for votes to question', js: true do
        expect(page).to have_link 'Голос вверх'
        expect(page).to have_link 'Голос вниз'
        expect(page).to_not have_link 'Отменить голос'
      end

      scenario 'vote up', js: true do
        click_on 'Голос вверх'
        expect(page).to have_text 'Рейтинг: 1'
        expect(page).to_not have_link 'Голос вверх'
        expect(page).to_not have_link 'Голос вниз'
        expect(page).to have_link 'Отменить голос'
      end

      scenario 'vote down', js: true do
        click_on 'Голос вниз'
        expect(page).to have_text 'Рейтинг: -1'
        expect(page).to_not have_link 'Голос вверх'
        expect(page).to_not have_link 'Голос вниз'
        expect(page).to have_link 'Отменить голос'
      end

      scenario 'vote cancel', js: true do
        create(:vote, votable: question, user: user)
        visit question_path(question)
        expect(page).to have_text 'Рейтинг: 1'
        expect(page).to_not have_link 'Голос вверх'
        expect(page).to_not have_link 'Голос вниз'
        expect(page).to have_link 'Отменить голос'

        click_on 'Отменить голос'
        expect(page).to have_text 'Рейтинг: 0'
        expect(page).to have_link 'Голос вверх'
        expect(page).to have_link 'Голос вниз'
        expect(page).to_not have_link 'Отменить голос'
      end
    end

    scenario 'author question tries to vote', js: true do
      sign_in(question.user)
      visit question_path(question)
      expect(page).to have_text 'Рейтинг: 0'
      expect(page).to_not have_link 'Голос вверх'
      expect(page).to_not have_link 'Голос вниз'
    end
  end

  scenario 'Non-authenticated user tries', js: true do
    visit question_path(question)
    expect(page).to have_text 'Рейтинг: 0'
    expect(page).to_not have_link 'Голос вверх'
    expect(page).to_not have_link 'Голос вниз'
  end
end
