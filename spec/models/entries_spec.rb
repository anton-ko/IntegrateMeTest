require "rails_helper"

describe Entry do
  include ActiveJob::TestHelper

  after do
    clear_enqueued_jobs
  end

  it "should enqueue SubscribeNewEntryJob on commit" do
    entry = create(:entry)
    entry.run_callbacks(:commit)

    expect(SubscribeNewEntryJob).to have_been_enqueued
  end
end
