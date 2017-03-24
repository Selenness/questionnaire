require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question with answers
  As an authenticate user
  I want to be able to delete question
}do
  let!(:question) { create(:question, :with_answers, :with_user_id) }
  let!(:user) { create(:user) }

  scenario 'Authenticated user delete his question' do
    sign_in(question.user)
    visit questions_path
    find("[href=\"#{question_path(question.id)}\"][data-method=\"delete\"]").click
    expect(page).not_to have_selector("[href=\"#{question_path(question.id)}\"]")
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit questions_path
    expect(page).not_to have_selector("[href=\"#{question_path(question.id)}\"][data-method=\"delete\"]")
  end

  scenario "Authenticated user tries delete question which doesn't belog to him" do
    sign_in(user)
    visit questions_path
    expect(page).not_to have_selector("[href=\"#{question_path(question.id)}\"][data-method=\"delete\"]")
  end
end