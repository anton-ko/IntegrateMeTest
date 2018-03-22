require 'rails_helper'

RSpec.describe "Account Settings", type: :request do
  describe "PUT /account_settings.json" do
    it "saves settings and returns " do
      put account_settings_path, {
        account: { mailchimp_key: 'test-key' },
        format: :json
      }

      expect(Account.find_current_account.mailchimp_key).to eq('test-key')

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq('{"success":true}')
    end
  end
end
