FactoryGirl.define do
  sequence :title do |n|
    "title#{n}"
  end

  sequence :body do |n|
    "body#{n}"
  end

  factory :question do
    title
    body
    association :user
  end

  trait :with_answers do
    after :create do |question|

      FactoryGirl.create_list :answer, 2, question: question, user: create(:user)
    end
  end

  trait :with_user_id do
    after :create do |question|
      user = create(:user)
      question.update_attribute(:user_id, user.id)
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
