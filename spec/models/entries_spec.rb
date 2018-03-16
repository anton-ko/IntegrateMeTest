require "rails_helper"

describe Entry do

  it "should enqueue SubscribeNewEntryJob on commit" do
    create(:entry)
    expect(SubscribeNewEntryJob).to have_been_enqueued
  end
end
