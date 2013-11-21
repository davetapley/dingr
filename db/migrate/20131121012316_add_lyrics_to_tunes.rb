class AddLyricsToTunes < ActiveRecord::Migration
  def change
    add_column :tunes, :lyrics, :string, array: true, default: []
  end
end
