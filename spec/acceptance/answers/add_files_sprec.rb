# frozen_string_literal: true
require_relative '../acceptance_helper'

feature 'Add files to answer', "
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'User adds files to answer' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'one file', js: true do
      fill_in 'Текст ответа', with: 'My answer text'
      attach_file 'File', "#{Rails.root}/spec/support/test_file.dat"
      click_on 'Ответить'

      within '.answers' do
        expect(page).to have_link 'test_file.dat', href: '/uploads/attachment/file/1/test_file.dat'
      end
    end

    scenario 'several files', js: true do
      fill_in 'Текст ответа', with: 'My answer text'
      click_on 'Добавить файл'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/support/test_file.dat")
      inputs[1].set("#{Rails.root}/public/favicon.ico")
      click_on 'Ответить'

      within '.answers' do
        expect(page).to have_link 'test_file.dat', href: '/uploads/attachment/file/1/test_file.dat'
        expect(page).to have_link 'favicon.ico', href: '/uploads/attachment/file/2/favicon.ico'
      end
    end
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Текст ответа', with: 'My answer text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ответить'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  context 'multiple sessions' do
    scenario "answer with files appears on another user's page", js: true do
      answer_text = 'Текст ответа'
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Текст ответа', with: answer_text
        click_on 'Добавить файл'
        inputs = all('input[type="file"]')
        inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
        inputs[1].set("#{Rails.root}/public/favicon.ico")
        click_on 'Ответить'

        within '.answers' do
          expect(page).to have_link 'test_file.dat', href: '/uploads/attachment/file/1/test_file.dat'
          expect(page).to have_link 'favicon.ico', href: '/uploads/attachment/file/2/favicon.ico'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content answer_text
          expect(page).to have_link 'test_file.dat', href: '/uploads/attachment/file/1/test_file.dat'
          expect(page).to have_link 'favicon.ico', href: '/uploads/attachment/file/2/favicon.ico'
        end
      end
    end
  end
end
