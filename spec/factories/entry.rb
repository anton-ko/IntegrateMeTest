FactoryBot.define do
  factory :entry do
    competition
    name { 'John Smith' }
    sequence(:email) { |n| "entry#{n}@example.com" }
  end
end
