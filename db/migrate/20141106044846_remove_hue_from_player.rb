class RemoveHueFromPlayer < ActiveRecord::Migration
  def change
    remove_column :players, :hue, :integer
  end
end
