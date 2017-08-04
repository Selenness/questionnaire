require 'rails_helper'

RSpec.describe NotifyJob, type: :class do
  before { clear_enqueued_jobs }
  describe 'notify subscribers about new answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:notification) { create(:notification, user_id: user, question_id: question) }

    it 'sends notification' do
      expect { perform_enqueued_jobs {
        answer = create(:answer, question: question)
        enqueued_jobs.each { |job| ActionMailer::DeliveryJob.perform_now(*job[:args]) }
      } }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end