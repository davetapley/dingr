class VersionsController < ApplicationController

  def show
    @tune = Tune.find params[:tune_id]

    if params[:id] == 'best'
      @version = @tune.match_notes(Player.notes).best_version
    elsif key = Note.parse(params[:id])
      @version = @tune.transpose_to_version key
    else
      match_versions = @tune.match_notes(Player.notes).versions
      @version = match_versions.at params[:id].to_i - 1
    end

    raise ActiveRecord::RecordNotFound unless @version.present?
  end

end

