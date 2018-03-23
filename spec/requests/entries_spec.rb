require 'rails_helper'

RSpec.describe "Entries", type: :request do
  describe "POST /entries.json" do
    it "saves new entry and submits email to mailchimp" do
      member_id = Digest::MD5.hexdigest('john.doe@example.com')

      mock_request = stub_request(:put, "https://us00.api.mailchimp.com/3.0/lists/a0000aa0aa/members/#{member_id}")
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
              competition_id: create(:competition, requires_entry_name: true, mailing_list_id: 'a0000aa0aa').id,
              name: 'John Doe',
              email: 'john.doe@example.com'
            },
            format: :json
          }
        end.to change { Entry.count }.by(1)
      end

      expect(mock_request).to have_been_made

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq('{"success":true}')
    end
  end
end
