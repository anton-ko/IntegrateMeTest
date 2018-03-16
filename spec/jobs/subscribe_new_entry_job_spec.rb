require 'rails_helper'

RSpec.describe SubscribeNewEntryJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(create(:entry)) }

  it 'sends email through to mailchimp' do
    expect(Gibbon::Request).to receive_message_chain(:lists, :members, :create)
    perform_enqueued_jobs { job }
  end
end
