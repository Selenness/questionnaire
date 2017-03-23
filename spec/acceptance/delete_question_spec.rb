require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question with answers
  As an authenticate user
  I want to be able to delete question
}do
  let!(:question) { create(:question, :with_answers, :with_user_id) }
  let!(:user) { create(:user) }

  scenario 'Authenticated user delete question' do
    user = question.user
    sign_in(user)
    visit questions_path
    find("[href=\"#{question_path(question.id)}\"][data-method=\"delete\"]").click
    expect(page).not_to have_selector("[href=\"#{question_path(question.id)}\"]")
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit questions_path
    find("[href=\"#{question_path(question.id)}\"][data-method=\"delete\"]").click
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario "Authenticated user tries delete question which don't belog to him" do
    sign_in(user)
    visit questions_path
    find("[href=\"#{question_path(question.id)}\"][data-method=\"delete\"]").click
    expect(page).to have_selector("[href=\"#{question_path(question.id)}\"]")
  end
end