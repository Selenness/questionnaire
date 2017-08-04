class DigestJob < ApplicationJob
  queue_as :mailers

  def perform
    @mails = User.pluck(:email)
    @mails.each do |email|
      DigestMailer.daily(email).deliver_later
    end
  end
end