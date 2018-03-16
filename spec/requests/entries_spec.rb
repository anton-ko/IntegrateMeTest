require 'rails_helper'

RSpec.describe "Entries", type: :request do
  describe "POST /entries.json" do
    it "saves new entry and submits email to mailchimp" do
      stub_request(:put, "https://us00.api.mailchimp.com/3.0/lists/a0000aa0aa/members/8eb1b522f60d11fa897de1dc6351b7e8")
        .with(body: {
            email_address: "john.doe@example.com",
            status: "subscribed",
            merge_fields: {FNAME: "John", LNAME: "Doe"}
          }.to_json)
        .to_return(status: 200, body: "", headers: {})

      perform_enqueued_jobs do
        expect do
          post entries_path, {
            entry: {
              competition_id: create(:competition, requires_entry_name: true).id,
              name: 'John Doe',
              email: 'john.doe@example.com'
            },
            format: :json
          }
        end.to change { Entry.count }.by(1)
      end
    end
  end
end
