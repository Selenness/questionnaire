class RequestEmailController < ApplicationController

  def request_email
    @provider = params[:provider]
    @uid = params[:uid]
  end

  def send_confirmation_email
    email = params[:user][:email]
    user = User.find_by_email(email)
    if user.present? && user.confirmed_email? && user.authorizations.find_by_provider_and_uid(params[:user][:provider], params[:user][:uid]).present?
      sign_in_and_redirect user, event: :authentication
    else
      secret_key = Devise.friendly_token(30)
      if user.nil?
        password = Devise.friendly_token(6)
        user = User.create(email: email, password: password, password_confirmation: password)
      end
      user.update_attribute(:confirmation_token, secret_key)
      ConfirmationMailer.send_confirmation(email, secret_key, params[:provider], params[:uid]).deliver
      redirect_to email_sent_path
    end
  end

  def receive_confirmation
    user = User.find_by_email(params[:email])
    if user.confirmation_token == params[:secret_key]
      user.update_attribute(:confirmed_email, true)
      user.authorizations.create(provider: params[:provider], uid: params[:uid])
      sign_in_and_redirect user
    else
      redirect root_path
    end
  end
end