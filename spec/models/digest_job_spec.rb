require 'rails_helper'

RSpec.describe DigestJob, type: :class do
  before { clear_enqueued_jobs }
  describe '.send daily digest' do
    let!(:users) { create_list(:user, 2) }
    let!(:question) { create(:question, user: users.first) }
    
    it 'should deliver digest emails' do
      expect { perform_enqueued_jobs {
        DigestJob.perform_later
        enqueued_jobs.each { |job| ActionMailer::DeliveryJob.perform_now(*job[:args]) }
      } }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end
end