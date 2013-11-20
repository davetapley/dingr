class VersionsController < ApplicationController

  def show
    @tune = Tune.find params[:tune_id]
    match_notes = @tune.match_notes Player.notes

    match = match_notes[:matches].at(params[:id].to_i - 1)

    raise ActiveRecord::RecordNotFound unless match.present?
    @notes = @tune.notes.map { |n| match[n] }
  end

end

