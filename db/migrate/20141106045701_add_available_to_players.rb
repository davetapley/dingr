class AddAvailableToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :available, :boolean, null: false, default: true
  end
end
