require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I want to be able to edit answer
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_answers) }
  # given(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user tries to edit answer', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Author of answer' do
    before do
      sign_in question.answers.first.user
      visit question_path(question)
    end

    scenario 'sees link to Edit', js: true do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries edits his answer', js: true do
      click_on "Edit"
      within '.answers' do
        fill_in "Body", with: "edited answer"
        click_on "Update"
      end

      expect(page).to_not have_content question.answers.first.body
      expect(page).to have_content "edited answer"
    end

    describe 'Non-author of answer' do
      before do
        sign_in user
        visit question_path(question)
      end

      scenario "tries edits other's question" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end