class WelcomeController < ApplicationController
  include CompetitionsHelper

  def index
    @competitions = Competition.all.with_entries_counts.order('competitions.created_at desc')
      .map do |competition|
      competition
          .slice(:id, :name, :entries_count, :mailing_list_id, :mailing_list_name, :mailing_list_url)
          .merge(path: competition_entrant_page(competition))
      end


    @account = current_account
  end
end
