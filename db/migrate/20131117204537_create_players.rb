class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :semitones, array: true, default: []

      t.timestamps
    end
  end
end
