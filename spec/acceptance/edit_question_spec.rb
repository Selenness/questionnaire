require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I want to be able to edit question
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_answers) }
  # given(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user tries to edit question', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Author of question' do
    before do
      sign_in question.user
      visit question_path(question)
    end

    scenario 'sees link to Edit', js: true do
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries edits his question', js: true do
      within '.question' do
        click_on "Edit"
      end

      within '.edit_question' do
        fill_in "Title", with: "edited question title"
        fill_in "Body", with: "edited question"
        click_on "Update"
      end
      expect(page).to_not have_content question.body
      expect(page).to_not have_content question.title
      expect(page).to have_content "edited question title"
      expect(page).to have_content "edited question"

    end
  end

  describe 'Non-author of question' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario "Authenticated user tries edits other's question" do
      expect(page).to_not have_link 'Edit'
    end
  end

end