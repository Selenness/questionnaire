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

      fill_in "Email", with: "test@test.com"
      click_on 'Verify email'
      open_email('test@test.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_link('Sign out')
    end
  end
end
