require 'rails_helper'

RSpec.describe EmailSubscriptionHandler do
  it 'adds an email address to a mailing list' do
    entry = build(:entry)
    lists = double('lists')
    members = double('members')

    members = stub_gibbon_members(entry.competition.mailing_list_id, entry.email)
    expect(members).to receive(:upsert).with(body: {
      email_address: entry.email,
      status: 'subscribed',
      merge_fields: { FNAME: entry.first_name, LNAME: entry.last_name }
    })

    EmailSubscriptionHandler
      .new(entry.competition.mailing_list_id)
      .subscribe(entry.email, entry.first_name, entry.last_name)
  end


  it 'raises ServiceError if connection failed' do
    stub_request(:put, "https://us00.api.mailchimp.com/3.0/lists/a0000aa0aa/members/8cc2188c903599b15cc86df4775badbb")
      .with(body: {
        email_address: "jane_doe@example.com",
        status: "subscribed",
        merge_fields: { "FNAME":"Jane", "LNAME":"Doe" }
      })
      .to_timeout

    expect do
      EmailSubscriptionHandler
        .new(Competition.new.mailing_list_id)
        .subscribe('jane_doe@example.com', 'Jane', 'Doe')
    end.to raise_error(EmailSubscriptionHandler::ServiceError)
  end

  it 'raises SubscriptionError if there is an issue with sent data' do
    entry = build(:entry)

    members = stub_gibbon_members(entry.competition.mailing_list_id, entry.email)
    expect(members).to receive(:upsert).with(body: {
      email_address: entry.email,
      status: 'subscribed',
      merge_fields: { FNAME: entry.first_name, LNAME: entry.last_name }
    }).and_raise(Gibbon::MailChimpError.new('Invalid Resource', status_code: 400))

    expect do
      EmailSubscriptionHandler
        .new(entry.competition.mailing_list_id)
        .subscribe(entry.email, entry.first_name, entry.last_name)
    end.to raise_error(EmailSubscriptionHandler::SubscriptionError)
  end


end
