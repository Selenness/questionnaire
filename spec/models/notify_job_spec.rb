require 'rails_helper'

RSpec.describe NotifyJob, type: :class do
  before { clear_enqueued_jobs }
  describe 'notify subscribers about new answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:notification) { create(:notification, user_id: user, question_id: question) }

    it 'sends notification' do
      answer = create(:answer, question: question)
      expect(NotificationsMailer).to receive(:new_answer).with(user: user, question: question, answer: answer).and_call_original
      NotifyJob.perform_now(answer)
    end
  end
end