require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }

  describe 'Answers ordering' do
    let!(:question) { create(:question, :with_answers) }
    let(:new_answer) { create(:answer, question: question, user: create(:user)) }

    it 'should place best answer first' do
      new_answer.update_attribute(:best_answer, true)
      expect(question.answers.first.id).to eq new_answer.id
    end
  end
end
