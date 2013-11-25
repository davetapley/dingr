class Tune < ActiveRecord::Base

  def self.parse(input)
    Tune.new crotchets: Tune.parse_crotchets(input)
  end

  def crotchets=(crotchets)
    unless crotchets.kind_of?(Array) && crotchets.first && crotchets.first.kind_of?(Crotchet)
      crotchets = Tune.parse_crotchets crotchets
    end

    write_attribute :crotchets, crotchets.collect { |c| c.to_s(:db) }
  end

  def crotchets
    read_attribute(:crotchets).collect do |c|
      ['r', '𝄽'].include?(c) ? Rest.new : Note.new(c.to_i)
    end
  end

  def uniq_notes
    crotchets.find_all { |c| c.kind_of? Note }.uniq
  end

  def crotchets_lyrics
    crotchets.zip lyrics
  end

  class MatchResult < Struct.new(:best_match_count, :versions)
  end

  class MatchVersion < Struct.new(:mapping, :transpose)
  end

  def match_notes(match_notes)
    match_notes_uniq_sort = match_notes.uniq.sort
    lowest_tune_note, normalized_tune_semitones = Note.normalize_to_semitones uniq_notes

    best_match_count = 0

    matches = (0 .. match_notes_uniq_sort.size).collect do |match_note_offset|
      remaining_match_notes = match_notes_uniq_sort.from match_note_offset

      lowest_match_note, normalized_remaining_semitones = Note.normalize_to_semitones remaining_match_notes

      intersection = normalized_tune_semitones & normalized_remaining_semitones
      best_match_count = [best_match_count, intersection.size].max

      next nil unless intersection.size == normalized_tune_semitones.size

      mapping = intersection.map do |s|
        tune_note = Note.new lowest_tune_note.semitone + s
        match_note = Note.new lowest_match_note.semitone + s
        [tune_note, match_note]
      end

      mapping = Hash[mapping]

      MatchVersion.new mapping, transpose(mapping)
    end

    MatchResult.new best_match_count, matches.compact
  end

  def transpose(mapping)
    transpose = dup
    transpose.crotchets = crotchets.map do |c|
      c.kind_of?(Rest) ? c : mapping[c]
    end
    transpose
  end

  def key
    crotchets.find { |c| c.is_a? Note }
  end

  private

  def self.parse_crotchets(input)
    unless input.kind_of? Array
      input = input.split input.include?(',') ? ',' : ' '
    end

    input.map do |c|
      next unless c.present?
      ['r', '𝄽'].include?(c) ? Rest.new : Note.parse(c)
    end.compact
  end

end
