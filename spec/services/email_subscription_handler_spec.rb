require 'rails_helper'

RSpec.describe EmailSubscriptionHandler do
  it 'adds an email address to a mailing list' do
    entry = build(:entry)
    lists = double('lists')
    members = double('members')

    # Gibbon call chain: Gibbon::Request.lists.members.upsert
    expect(Gibbon::Request).to receive(:lists).with(entry.competition.mailing_list_id).and_return(lists)
    expect(lists).to receive(:members).with(Digest::MD5.hexdigest(entry.email)).and_return(members)
    expect(members).to receive(:upsert).with(body: {
      email_address: entry.email,
      status: 'subscribed',
      merge_fields: { FNAME: entry.first_name, LNAME: entry.last_name }
    })

    EmailSubscriptionHandler
      .new(entry.email)
      .subscribe(entry.competition.mailing_list_id, entry.first_name, entry.last_name)
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
        .new('jane_doe@example.com')
        .subscribe(Competition.new.mailing_list_id, 'Jane', 'Doe')
    end.to raise_error(EmailSubscriptionHandler::ServiceError)
  end

  it 'raises SubscriptionError if there is an issue with sent data' do
    entry = build(:entry)
    lists = double('lists')
    members = double('members')

    # Gibbon call chain: Gibbon::Request.lists.members.upsert
    expect(Gibbon::Request).to receive(:lists).with(entry.competition.mailing_list_id).and_return(lists)
    expect(lists).to receive(:members).with(Digest::MD5.hexdigest(entry.email)).and_return(members)
    expect(members).to receive(:upsert).with(body: {
      email_address: entry.email,
      status: 'subscribed',
      merge_fields: { FNAME: entry.first_name, LNAME: entry.last_name }
    }).and_raise(Gibbon::MailChimpError.new('Invalid Resource', status_code: 400))

    expect do
      EmailSubscriptionHandler
        .new(entry.email)
        .subscribe(entry.competition.mailing_list_id, entry.first_name, entry.last_name)
    end.to raise_error(EmailSubscriptionHandler::SubscriptionError)
  end


end
