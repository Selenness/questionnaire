class DigestJob
  include Sidekiq::Worker
  sidekiq_options queue: :mailers

  def perform
    DigestMailer.daily.deliver
  end
end