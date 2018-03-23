class MailingListsController < ApplicationController
  before_action :ensure_api_key_presence!

    # GET /mailing-lists.json
  def index
    cache_key = "#{current_account.id}/lists/#{Digest::MD5.hexdigest(current_account.mailchimp_key)}"

    mailing_lists = Rails.cache.fetch(cache_key, expires_in: 15.seconds) do
      MailingListService.new(current_account.mailchimp_key).lists
    end

    if mailing_lists
      render json: {success: true, mailing_lists: mailing_lists}
    else
      render json: {success: false, error: :api_key}
    end
  end

  private

  def ensure_api_key_presence!
    return unless current_account.mailchimp_key.blank?
    render json: { success: false, error: :api_key }
  end
end
