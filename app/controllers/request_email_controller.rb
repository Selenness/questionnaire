class RequestEmailController < ApplicationController

  def send_confirmation_email
    user = User.perform_confirmation(params[:user][:email], session[:provider], session[:uid])
    if user.present?
      sign_in_and_redirect user, event: :authentication
    else
      redirect_to email_sent_path
    end
  end

  def receive_confirmation
    user = User.find_by_email(params[:email])
    if user.confirmation_token == params[:secret_key]
      user.confirm_email
      user.authorizations.create(provider: session[:provider], uid: session[:uid])
      sign_in_and_redirect user
    else
      redirect_to root_path
    end
  end
end