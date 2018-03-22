class WelcomeController < ApplicationController
  def index
    @competitions = Competition.all.with_entries_counts.order('competitions.created_at desc')
    @account = current_account
  end
end
