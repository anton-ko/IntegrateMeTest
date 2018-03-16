FactoryBot.define do
  factory :entry do
    competition
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
