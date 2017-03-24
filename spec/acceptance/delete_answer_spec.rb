require 'rails_helper'

feature 'Delete answer', %q{
  In order to delete user's answer
  As an authenticated user
  I want to be able to delete the answer
} do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, :with_answers) }

  scenario "Non-uthenticated user tries to delete answer" do
    visit question_path(id: question.id)
    expect(page).to_not have_selector("[href=\"#{question_answer_path(question_id: question.id, id: question.answers.first.id)}\"]")
  end

  scenario "Authenticated user tries to delete other's answer" do
    sign_in(user)
    visit question_path(id: question.id)
    expect(page).to_not have_selector("[href=\"#{question_answer_path(question_id: question.id, id: question.answers.first.id)}\"]")
  end

  scenario "Authenticated user tries to delete his answer" do
    sign_in(question.answers.first.user)
    visit question_path(id: question.id)
    find("[href=\"#{question_answer_path(question_id: question.id, id: question.answers.first.id)}\"][data-method=\"delete\"]").click
    expect(page).to have_selector("[href=\"#{question_answer_path(question_id: question.id, id: question.answers.first.id)}\"]")
  end
end