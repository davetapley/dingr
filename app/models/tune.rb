class Tune < ActiveRecord::Base

  def self.parse(input)
    Tune.new notes: input.split(' ').map { |n| Note.parse n }
  end

  def notes=(notes)
    self.semitones = notes.collect do |n|
      n.semitone
    end
  end

  def notes
    semitones.collect do |s|
      Note.new s.to_i
    end
  end

  def match_notes(match_notes)
    match_notes_uniq_sort = match_notes.uniq.sort
    lowest_tune_note, normalized_tune_semitones = Note.normalize_to_semitones notes

    best_match_count = 0

    matches = (0 .. match_notes_uniq_sort.size).collect do |match_note_offset|
      remaining_match_notes = match_notes_uniq_sort.from match_note_offset

      lowest_match_note, normalized_remaining_semitones = Note.normalize_to_semitones remaining_match_notes

      intersection = normalized_tune_semitones & normalized_remaining_semitones
      best_match_count = [best_match_count, intersection.size].max

      next nil unless intersection.size == normalized_tune_semitones.size

      match = intersection.map do |s|
        tune_note = Note.new lowest_tune_note.semitone + s
        match_note = Note.new lowest_match_note.semitone + s
        [tune_note, match_note]
      end

      Hash[match]
    end

    { best_match_count: best_match_count, matches: matches.compact }

  end


end
