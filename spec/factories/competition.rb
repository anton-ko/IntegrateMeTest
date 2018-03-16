FactoryBot.define do
  factory :competition do
    sequence(:name) { |n| "Competion #{n}!" }
    requires_entry_name false
  end
end
