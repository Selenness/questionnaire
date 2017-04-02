require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to delete user's answer
  As an authenticated user
  I want to be able to delete the answer
} do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, :with_answers) }

  scenario "Non-uthenticated user tries to delete answer" do
    visit question_path(id: question.id)
    expect(page).to_not have_link "Delete"
  end

  scenario "Authenticated user tries to delete other's answer" do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link "Delete"
  end

  scenario "Authenticated user tries to delete his answer" do
    sign_in(question.answers.first.user)
    visit question_path(question)
    answer_body = question.answers.first.body
    expect(page).to have_content answer_body
    click_on "Delete"
    expect(page).not_to have_content answer_body
  end
end