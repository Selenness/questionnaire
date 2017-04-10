require_relative 'acceptance_helper'

feature 'Delete attachments from question', %q{
  In order to change files
  As an author of question
  I want to be able to delete file
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(id: question.id)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Author deletes file from question', js: true do
    sign_in(user)
    visit question_path(id: question.id)
    within '.question' do
      click_on 'Delete'
    end
    expect(page).to_not have_link attachment.file.filename, href: attachment.file.url
  end

  scenario "Authenticated user tries to delete file from other's question", js: true do
    sign_in(create(:user))
    visit question_path(id: question.id)
    within '.attachments' do
      expect(page).to_not have_link 'Delete'
    end
  end
end