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
      Note.new s
    end
  end

  def match_notes(match_notes)
    match_notes_uniq_sort = match_notes.uniq.sort
    normalized_tune_semitones = Note.normalize_to_semitones(notes).last

    (0 .. match_notes_uniq_sort.size).collect do |match_note_offset|
      remaining_match_notes = match_notes_uniq_sort.from match_note_offset
      next nil unless remaining_match_notes.size >= normalized_tune_semitones.size

      lowest_match_note, normalized_remaining_semitones = Note.normalize_to_semitones remaining_match_notes

      intersection = normalized_tune_semitones & normalized_remaining_semitones

      next nil unless intersection.size == normalized_tune_semitones.size

      match_notes = intersection.map { |s| Note.new s + lowest_match_note.semitone }

      { offset: lowest_match_note, notes: match_notes }
    end.compact

  end


end
