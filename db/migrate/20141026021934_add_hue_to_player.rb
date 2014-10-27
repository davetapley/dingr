class AddHueToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :hue, :integer
  end
end
