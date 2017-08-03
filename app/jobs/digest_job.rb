class DigestJob < ApplicationJob
  queue_as :mailers

  def perform
    DigestMailer.daily.deliver_now
  end
end