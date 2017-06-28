class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :authorizations

  has_many :questions
  has_many :answers
  has_many :user_votes

  def author_of?(entry)
    entry.user_id == self.id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info.email
    user = User.where(email: email).first
    if user
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    else
      user = User.create_with_password(email)
      user.authorizations.create(provider: auth.provider, uid: auth.uid) if user.persisted?
    end
    user
  end

  def send_confirmation_email(provider, uid)
    secret_key = Devise.friendly_token(30)
    self.update_column(:confirmation_token, secret_key)
    ConfirmationMailer.send_confirmation(email, secret_key, provider, uid).deliver
  end

  def self.create_with_password(email)
    password = Devise.friendly_token[0, 20]
    User.create(email: email, password: password, password_confirmation: password)
  end

  def existed_and_has_authorization?(provider, uid)
    self.confirmed_email? && self.authorizations.find_by_provider_and_uid(provider, uid).present?
  end

  def self.perform_confirmation(email, provider, uid)
    user = User.find_by_email(email)
    if user.present? && user.existed_and_has_authorization?(provider, uid)
      user
    else
      user = User.create_with_password(email) if user.nil?
      user.send_confirmation_email(provider, uid)
      nil
    end
  end

  def confirm_email
    self.update_attribute(:confirmed_email, true)
  end
end
