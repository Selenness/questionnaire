require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to create question
} do
  given(:user) { create(:user) }

  scenario 'User create invalid question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: nil
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Authenticated user create question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'
    click_on 'Create'

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Text text'
  end

  scenario 'Non-authenticated user tries create question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end


end