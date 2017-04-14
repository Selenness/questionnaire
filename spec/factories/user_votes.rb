FactoryGirl.define do
  factory :user_vote do
    user nil
    votable_id 1
    votable_type "Answer"
  end

  factory :invalid_user_vote, class: 'UserVote' do
    
  end
end
