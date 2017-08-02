require 'rails_helper'

RSpec.describe DigestJob, type: :class do
  describe '.send daily digest' do
    let!(:users) { create_list(:user, 2) }
    let!(:questions) { create_list(:question, 2) }

    it 'should send daily digest to all users' do
      expect { DigestJob.new.perform }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end