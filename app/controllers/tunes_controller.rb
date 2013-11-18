class TunesController < ApplicationController

  def index
    @notes = Player.notes
    @tunes = Tune.all
  end

end
