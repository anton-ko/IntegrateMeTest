require 'rails_helper'

RSpec.describe SubscribeNewEntryJob, type: :job do
  include ActiveJob::TestHelper

  it 'sends email through to mailchimp' do
    expect(Gibbon::Request).to receive_message_chain(:lists, :members, :upsert)
    SubscribeNewEntryJob.perform_now(create(:entry))
  end
end
