FactoryBot.define do
  factory :competition do
    sequence(:name) { |n| "Competion #{n}!" }
  end
end
