require_relative 'acceptance_helper'

feature 'Delete attachments from answer', %q{
  In order to change files
  As an author of answer
  I want to be able to delete file
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(id: question.id)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Author deletes file from answer', js: true do
    sign_in(user)
    visit question_path(id: question.id)
    within "#span_answer_#{answer.id} .attachments" do
      click_on 'Delete'
    end
      expect(page).to_not have_link attachment.file.filename, href: attachment.file.url
  end

  scenario "Authenticated user tries to delete file from other's answer", js: true do
    sign_in(create(:user))
    visit question_path(id: question.id)
    within "#span_answer_#{answer.id} .attachments" do
      expect(page).not_to have_link 'Delete'
    end
  end
end