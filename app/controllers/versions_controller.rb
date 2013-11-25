class VersionsController < ApplicationController

  def show
    @tune = Tune.find params[:tune_id]
    match_versions = @tune.match_notes(Player.notes).versions

    @version = match_versions.at params[:id].to_i - 1

    raise ActiveRecord::RecordNotFound unless @version.present?
  end

end

