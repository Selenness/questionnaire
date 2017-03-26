require 'rails_helper'

feature 'Sign out user', %q{
  In order to sign out
  As an authenticated user
  I want to sign out
}do
  let!(:user) { create(:user) }

  scenario 'Authenticated user click on sign out link' do
    sign_in(user)
    visit root_path
    click_on 'Sign out'
    expect(current_path).to eq root_path
    expect(page).not_to have_link('Sign out')
  end
end