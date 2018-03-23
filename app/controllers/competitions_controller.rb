class CompetitionsController < ApplicationController
  before_action :set_competition

  def entrant_page
    @entry = Entry.new(competition: @competition)
  end

  def update
    if competition_params[:mailing_list_id] == @competition.mailing_list_id # no changes
      render json: success_hash(@competition)
      return
    end

    @competition.attributes = competition_params
    if @competition.validate_mailing_list && @competition.save
      render json: success_hash(@competition)
    else
      render json: {success: false, error: @competition.errors.full_messages_for(:mailing_list_id).first}
    end
  end

  private
  def set_competition
    @competition = Competition.find(params[:competition_id])
  end

  def competition_params
    params.require(:competition).permit(:mailing_list_id)
  end

  def success_hash(competition)
    {success: true, competition: competition.slice(:mailing_list_name, :mailing_list_url)}
  end
end
