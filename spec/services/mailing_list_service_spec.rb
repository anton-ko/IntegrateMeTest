require 'rails_helper'

RSpec.describe MailingListService do
  let(:api_key) { "#{SecureRandom.hex(16)}-us00" }
  let(:entry) { build(:entry) }

  describe '.valid_api_key?' do
    context 'when key is valid' do
      it 'validates the key and returns true' do
        pending 'pending test implementation'
        fail
      end
    end

    context 'when key is invalid' do
      it 'validates the key and returns false' do
        pending 'pending test implementation'
        fail
      end
    end
  end

  it 'adds an email address to a mailing list' do
    members = stub_gibbon_members(api_key, entry.competition.mailing_list_id, entry.email)
    expect(members).to receive(:upsert).with(body: {
      email_address: entry.email, status: 'subscribed', merge_fields: { FNAME: entry.first_name, LNAME: entry.last_name }
    })

    MailingListService
      .new(api_key)
      .subscribe(entry.competition.mailing_list_id, entry.email, entry.first_name, entry.last_name)
  end

  it 'raises ServiceError if connection failed' do
    list_id = SecureRandom.hex(5)

    stub_request(:put, "https://us00.api.mailchimp.com/3.0/lists/#{list_id}/members/8cc2188c903599b15cc86df4775badbb")
      .with(body: {
        email_address: "jane_doe@example.com", status: "subscribed", merge_fields: { "FNAME":"Jane", "LNAME":"Doe" }
      })
      .to_timeout

    expect do
      MailingListService
        .new(api_key)
        .subscribe(list_id, 'jane_doe@example.com', 'Jane', 'Doe')
    end.to raise_error(MailingListService::ServiceError)
  end

  it 'raises SubscriptionError if there is an issue with sent data' do
    members = stub_gibbon_members(api_key, entry.competition.mailing_list_id, entry.email)
    expect(members).to receive(:upsert).with(body: {
      email_address: entry.email,
      status: 'subscribed',
      merge_fields: { FNAME: entry.first_name, LNAME: entry.last_name }
    }).and_raise(Gibbon::MailChimpError.new('Invalid Resource', status_code: 400))

    expect do
      MailingListService
        .new(api_key)
        .subscribe(entry.competition.mailing_list_id, entry.email, entry.first_name, entry.last_name)
    end.to raise_error(MailingListService::SubscriptionError)
  end
end
