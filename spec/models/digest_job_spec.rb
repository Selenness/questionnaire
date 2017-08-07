require 'rails_helper'

RSpec.describe DigestJob, type: :class do
  before { clear_enqueued_jobs }
  describe '.send daily digest' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    
    it 'should deliver digest emails' do
      expect(DigestMailer).to receive(:daily).with(user.email).and_call_original
      DigestJob.perform_now
    end
  end
end