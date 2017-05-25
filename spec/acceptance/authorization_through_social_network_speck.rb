require_relative 'acceptance_helper'

feature 'social network authorization', %q{
  In order to use login
  As user
  I want to be able authorize through social network
} do

  context 'through twitter' do
    scenario 'user has already authorisation with twitter' do
      visit(new_user_session_path)
      mock_auth_hash
      click_on 'Sign in with Twitter'

      expect(page).to have_link('Sign out')
    end

    scenario 'user authorizes in first time' do
      visit(new_user_session_path)
      mock_auth_hash
      click_on 'Sign in with Twitter'


      fill_in "email", with: "test@test.com"
      click_on 'Confirm email'
      open_email('test@test.com')
      current_email.click_link 'Confirm account'

      expect(page).to have_link('Sign out')
    end
  end

  context 'through facebook' do
    scenario 'user has already authorisation with facebook' do
      visit(new_user_session_path)
      mock_auth_hash
      click_on 'Sign in with Facebook'

      expect(page).to have_link('Sign out')
    end

    scenario 'user authorizes in first time' do
      visit(new_user_session_path)
      mock_auth_hash
      click_on 'Sign in with Facebook'


      fill_in "email", with: "test@test.com"
      click_on 'Confirm email'
      open_email('test@test.com')
      current_email.click_link 'Confirm account'

      expect(page).to have_link('Sign out')
    end
  end
end
