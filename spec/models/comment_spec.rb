require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should validate_presence_of :text }

  it 'return hash for search' do
    comment = FactoryGirl.create(:comment)
    expect(comment.to_search_result).to eq(body: comment.text)
  end
end
