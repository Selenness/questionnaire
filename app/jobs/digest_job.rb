class DigestJob
  include Sidekiq::Worker
  sidekiq_options queue: :mailers

  def perform
    DigestMailer.daily.deliver_now
  end
end