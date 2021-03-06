FactoryGirl.define do

  factory :component do
    sequence(:component) { Faker::App.name }
    sequence(:position) { |n| (n%3)+1 }
    selected false

    trait :of_line_item do
      composable_type "LineItem"
      composable_id nil
    end

    factory :component_of_line_item, traits: [:of_line_item]
  end
end
