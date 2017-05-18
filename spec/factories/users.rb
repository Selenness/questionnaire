FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'

    factory :fb_user do
      confirmed_email true
      after :create do |user|
        create :authorization, provider: 'facebook', uid: '1234', user: user
      end
    end

    factory :tw_user do
      confirmed_email true
      after :create do |user|
        create :authorization, provider: 'twitter', uid: '1234', user: user
      end
    end
  end
end
