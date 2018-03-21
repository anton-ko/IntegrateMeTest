require "rails_helper"

describe Account do
  it "should obfuscate mailchimp key" do
    plain_text_key = '0000a0aa0a0000aaaa0a00000aa00000-us11'
    obfuscated_key = '***************************00000-us11'

    expect(Account.new(mailchimp_key: plain_text_key).mailchimp_key_obfuscated).to eq(obfuscated_key)
  end
end
