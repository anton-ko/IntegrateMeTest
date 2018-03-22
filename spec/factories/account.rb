FactoryBot.define do
  factory :account do
    trait :with_mailchimp do
      mailchimp_key { "#{SecureRandom.hex(16)}-us00" }
    end
  end
end
