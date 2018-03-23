require 'rails_helper'

RSpec.describe "Account Settings", type: :request do
  describe "PUT /account_settings.json" do
    it "saves settings and returns " do
      api_key = "574df63f08b9db4b6befac205e4c7876-us00"

      stub_request(:get, "https://us00.api.mailchimp.com/3.0/ping").
        to_return(status: 200, body: {health_status: 'ok'}.to_json, headers: {})

      put account_settings_path, {
        account: { mailchimp_key: api_key },
        format: :json
      }

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq({
        success: true,
        data: {
          mailchimp_key: "***************************c7876-us00"
        }
      }.to_json)

      expect(Account.find_current_account.mailchimp_key).to eq(api_key)
    end
  end
end
