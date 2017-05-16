class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorization_through_network
  end

  def twitter
    authorization_through_network
  end

  def authorization_through_network
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      redirect_to request_email_path(
                      provider: request.env['omniauth.auth'].provider,
                      uid: request.env['omniauth.auth'].uid
                  )
    end
  end
end