class NotesController < ApplicationController
  def index
    @player_notes = Player.notes
    match_results = Tune.all.map { |t| t.match_notes(@player_notes) }
    incomplete_results = match_results.find_all { |r| r.versions.empty? }

    missing_notes = incomplete_results.collect do |r|
      r.best_version.missing_notes.to_a
    end.inject(&:concat)

    @missing_notes_count = missing_notes.inject(Hash.new(0)) { |h, n| h[n] += 1 ; h }.sort_by(&:last).reverse
  end
end
