class PlayersController < ApplicationController

  def index
    @players = Player.unscoped.all
  end

  def create
    Player.create player_attributes

    redirect_to players_path
  end

  def update
    player = Player.unscoped.find params[:id]
    player.update_attributes player_attributes

    respond_with_bip player
  end

  private

  def player_attributes
    params.require(:player).permit(:name, :notes, :notes_string, :available)
  end

end
