FactoryBot.define do
  factory :competition do
    association :account, :with_mailchimp
    sequence(:name) { |n| "Competion #{n}!" }
    requires_entry_name false
  end
end
