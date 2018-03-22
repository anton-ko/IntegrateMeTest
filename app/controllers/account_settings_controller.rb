class AccountSettingsController < ApplicationController
  def edit
    render json: { mailchimp_key: current_account.mailchimp_key_obfuscated }
  end

  def update
    current_account.attributes = account_params

    if current_account.valid_api_keys? && current_account.save
      render json: { success: true }
    else
      render json: { success: false, errors: current_account.errors }
    end
  end

  private

  def account_params
    params.require(:account).permit(:mailchimp_key)
  end
end
