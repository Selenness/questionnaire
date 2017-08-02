require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent :destroy }
  it { should have_many :attachments }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments}
  it { should have_many :notifications }
  it { should have_and_belong_to_many(:subscribers).class_name('User').through(:notifications) }

  describe 'make author subscription after create question' do
    it 'makes notification' do
      question = FactoryGirl.build(:question)
      expect(Notification).to receive(:create).with(user_id: 1, question_id: 1)
      question.save
    end
  end
end
