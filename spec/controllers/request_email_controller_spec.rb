require 'rails_helper'

RSpec.describe RequestEmailController, type: :controller do

  it 'render view for email request' do
    get :request_email
    expect(response).to render_template :request_email
  end

  context 'POST #send_confirmation_email' do
    it 'signs in as user if user exists and is confirmed' do
      user = create(:fb_user)
      auth = user.authorizations.first

      post :send_confirmation_email, params: { user: { email: user.email } }, session: { provider: auth.provider, uid: auth.uid }
      expect(response).to redirect_to root_path
    end

    it 'signs in as user if user exists and is confirmed' do
      user = create(:tw_user)
      auth = user.authorizations.first
      post :send_confirmation_email, params: { user: { email: user.email } }, session: { provider: auth.provider, uid: auth.uid }
      expect(response).to redirect_to root_path
    end

    it 'says thanks to newly registered user' do
      post :send_confirmation_email, params: {  user: { email: 'test@test.test' }, provider: 'twitter', uid: '1234' }
      expect(response).to redirect_to email_sent_path
    end

    it 'creates user if he does not exist' do
      expect{ post :send_confirmation_email, params: {  user: { email: 'test@test.test' }, provider: 'twitter', uid: '1234' } }.to change(User, :count).by 1
    end
  end

  context 'GET #receive_confirmation' do
    it 'signs in user if secret key is correct' do
      secret_key = Devise.friendly_token(30)
      user = create(:user, confirmation_token: secret_key, confirmed_email: false)
      get :receive_confirmation, params: { email: user.email, secret_key: secret_key, provider: 'twitter', uid: '1234' }
      expect(controller.current_user).to eq(user)
    end

    it 'creates authorization for user' do
      secret_key = Devise.friendly_token(30)
      user = create(:user, confirmation_token: secret_key, confirmed_email: false)
      expect{ get :receive_confirmation, params: { email: user.email, secret_key: secret_key, provider: 'twitter', uid: '1234' } }.to change(Authorization, :count).by(1)
    end

    it 'updates attribute confirmed_email' do
      secret_key = Devise.friendly_token(30)
      user = create(:user, confirmation_token: secret_key, confirmed_email: false)
      get :receive_confirmation, params: { email: user.email, secret_key: secret_key, provider: 'twitter', uid: '1234' }
      user.reload
      expect(user.confirmed_email).to be true
    end

    it 'does not sign in user if secret key is not correct' do
      secret_key = Devise.friendly_token(30)
      user = create(:user, confirmation_token: secret_key, confirmed_email: false)
      get :receive_confirmation, params: { email: user.email, secret_key: Devise.friendly_token(30), provider: 'twitter', uid: '1234' }
      expect(controller.current_user).to_not eq(user)
      expect(response).to redirect_to root_path
    end
  end
end