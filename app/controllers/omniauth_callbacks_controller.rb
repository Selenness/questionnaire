class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :authorization_through_network

  def facebook
  end

  def twitter
  end

  private

  def authorization_through_network
    omniauth_auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(omniauth_auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session[:provider] = omniauth_auth.provider
      session[:uid] = omniauth_auth.uid
      redirect_to request_email_path
    end
  end
end