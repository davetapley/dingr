class TunesController < ApplicationController

  before_filter :find_tune, except: [:index, :new, :create]

  def index
    @notes = Player.notes
    @tunes = Tune.all.map { |t| [t, t.match_notes(@notes)] }
  end

  def show
    @match_versions = @tune.match_notes(Player.notes).versions
  end

  def new
    @tune = Tune.new
  end

  def create
    tune = Tune.create tune_attributes
    redirect_to edit_tune_path(tune)
  end

  def edit
  end

  def update
    @tune.update_attributes tune_attributes
    redirect_to edit_tune_path(@tune)
  end

  def insert_rest
    @tune.crotchets = @tune.crotchets.insert params[:crotchet_idx].to_i, Rest.new

    @tune.lyrics = @tune.lyrics.insert params[:crotchet_idx].to_i, ''
    @tune.lyrics_will_change!

    @tune.save
    redirect_to edit_tune_path(@tune)
  end

  def destroy
    @tune.destroy
    redirect_to tunes_path
  end

  private

  def find_tune
    @tune = Tune.find params[:id]
  end

  def tune_attributes
    params.require(:tune).permit(:name, :crotchets, crotchets: [], lyrics: [])
  end

end
