require 'rails_helper'

feature 'User registers', %q{
  In order to be able to use application
  As an new user
  I want to be able to register
} do


  scenario 'Registered user try to sign in' do
    visit new_user_registration_path
    fill_in "Email", with: "test@test.com"
    fill_in "Password", with: '123456'
    fill_in "Password confirmation", with: '123456'
    click_on "Sign up"
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end