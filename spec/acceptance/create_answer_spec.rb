require 'rails_helper'

feature 'Create answer to question', %q{
  In order to give answer to question
  As an authenticate user
  I want to be able to create answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticate user create answer'do
    sign_in(user)
    visit question_path(id: question.id)
    expect(page).to have_selector("form#new_answer")
    fill_in 'answer[body]', with: 'Test answer'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created'
  end

  scenario 'Non-authenticate user tries to create answer' do
    visit question_path(id: question.id)
    expect(page).to have_selector("form#new_answer")
    fill_in 'answer[body]', with: 'Test answer'
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end