require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent :destroy }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'Answers ordering' do
    let!(:question) { create(:question, :with_answers) }
    let(:new_answer) { create(:answer, question: question, user: create(:user)) }

    it 'should place best answer first' do
      question.update_attribute(:best_answer_id, new_answer.id)
      expect(question.answers.first.id).to eq new_answer.id
    end
  end
end
