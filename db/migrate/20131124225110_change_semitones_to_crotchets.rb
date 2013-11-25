class ChangeSemitonesToCrotchets < ActiveRecord::Migration
  def change
    rename_column :tunes, :semitones, :crotchets
  end
end
