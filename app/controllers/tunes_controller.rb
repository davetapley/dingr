class TunesController < ApplicationController

  def index
    @notes = Player.notes
    @tunes = Tune.all.map { |t| [t, t.match_notes(@notes)] }
  end

  def show
    @tune = Tune.find params[:id]
    match_notes = @tune.match_notes Player.notes

    @matches = match_notes[:matches]
  end

end
