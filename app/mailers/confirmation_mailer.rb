class ConfirmationMailer < ApplicationMailer
  def send_confirmation(email, secret_key, provider, uid)
    @email = email
    @secret_key = secret_key
    @provider = provider
    @uid = uid
    mail(to: email, subject: 'Email confirmation')
  end
end