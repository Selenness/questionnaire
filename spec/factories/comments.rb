FactoryGirl.define do
  factory :comment do
    text "MyText"

    factory :invalid_comment do
      text nil
    end
  end
end
