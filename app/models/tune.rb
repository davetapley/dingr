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
    normalized_tune_semitones = Note.normalize_to_semitones(notes).last

    best_match_count = 0

    match_notes = (0 .. match_notes_uniq_sort.size).collect do |match_note_offset|
      remaining_match_notes = match_notes_uniq_sort.from match_note_offset

      lowest_match_note, normalized_remaining_semitones = Note.normalize_to_semitones remaining_match_notes

      intersection = normalized_tune_semitones & normalized_remaining_semitones
      best_match_count = [best_match_count, intersection.size].max

      next nil unless intersection.size == normalized_tune_semitones.size

      match_notes = intersection.map { |s| Note.new s + lowest_match_note.semitone }

      { offset: lowest_match_note, notes: match_notes }
    end

    { best_match_count: best_match_count, matches: match_notes.compact }

  end


end
