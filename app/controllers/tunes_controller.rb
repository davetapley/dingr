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
    @crotchets_text = @tune.crotchets.in_groups_of(16).map { |row| row.map { |c| c.to_s.center 4 }.join(' ') }.join("\n")
    @lyrics_text = @tune.lyrics.in_groups_of(16).map { |row| row.map { |c| c.to_s.center 4 }.join(', ') }.join(",\n")
  end

  def update
    @tune.update_attributes tune_attributes
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
    params.require(:tune).permit(:name, :crotchets, :lyrics)
  end

end
