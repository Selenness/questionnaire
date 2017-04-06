require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments}
  it { should validate_presence_of :body }
  
  it { should accept_nested_attributes_for :attachments}

  describe 'Instance methods' do
    let!(:question) { create(:question, :with_answers) }

    it 'should set best answer' do
      question.answers.first.set_best
      expect(question.answers.first.best?).to be true
    end
  end

  describe 'Answers ordering' do
    let!(:question) { create(:question, :with_answers) }
    let(:new_answer) { create(:answer, question: question, user: create(:user)) }

    it 'should place best answer first' do
      new_answer.set_best
      expect(question.answers.first.id).to eq new_answer.id
    end
  end
end
