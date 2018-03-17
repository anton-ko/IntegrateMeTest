require 'rails_helper'

RSpec.describe SubscribeNewEntryJob, type: :job do
  it 'triggers email subscription handler' do
    entry = create(:entry)
    service = instance_double('EmailSubscriptionHandler')
    expect(EmailSubscriptionHandler).to receive(:new).with(entry.competition.mailing_list_id).and_return(service)
    expect(service).to receive(:subscribe).with(entry.email, entry.first_name, entry.last_name)

    SubscribeNewEntryJob.perform_now(entry)
  end
end
