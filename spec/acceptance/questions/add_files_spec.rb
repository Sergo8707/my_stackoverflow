# frozen_string_literal: true
require_relative '../acceptance_helper'

feature 'Add files to question', "
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
" do
  given(:user) { create(:user) }

  before do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in 'Заголовок', with: 'Test question'
    fill_in 'Ваш вопрос', with: 'text question'
    attach_file 'File', "#{Rails.root}/spec/support/test_file.dat"
    click_on 'Создать'

    expect(page).to have_link 'test_file.dat', href: '/uploads/attachment/file/1/test_file.dat'
  end

  scenario 'User adds several files when asks question', js: true do
    fill_in 'Заголовок', with: 'Test question'
    fill_in 'Ваш вопрос', with: 'text question'
    click_on 'Добавить файл'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/support/test_file.dat")
    inputs[1].set("#{Rails.root}/spec/support/test_file.dat")
    click_on 'Создать'

    expect(page).to have_link 'test_file.dat', href: '/uploads/attachment/file/1/test_file.dat'
    expect(page).to have_link 'test_file.dat', href: '/uploads/attachment/file/2/test_file.dat'
  end
end
