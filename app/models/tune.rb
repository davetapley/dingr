class Tune < ActiveRecord::Base
  def self.parse(input)
    Tune.new crotchets: Tune.parse_crotchets(input)
  end

  def crotchets=(crotchets)
    unless crotchets.compact.any? { |c| c.is_a? Crotchet }
      crotchets = Tune.parse_crotchets crotchets
    end
    crotchets = crotchets.collect { |c| c.nil? ? nil : c.to_s(:db) }
    write_attribute :crotchets, crotchets
  end

  def crotchets
    read_attribute(:crotchets).collect do |c|
      ['r', '𝄽'].include?(c) ? Rest.new : Note.new(c.to_i)
    end
  end

  def lyrics=(lyrics)
    unless lyrics.kind_of?(Array)
      lyrics = Tune.parse_lyrics lyrics
    end

    write_attribute :lyrics, lyrics
  end

  def uniq_notes
    crotchets.find_all { |c| c.kind_of? Note }.uniq
  end

  def crotchets_lyrics
    crotchets.zip lyrics
  end

  class MatchResult < Struct.new(:best_version, :versions)
  end

  class MatchVersion < Struct.new(:mapping, :transpose)
    def available_mapping
      return @available_mapping unless @available_mapping.nil?

      @available_mapping = mapping.dup
      @available_mapping.keep_if do |tune_note, version_note|
        Player.with_note(version_note).present?
      end
      @available_mapping
    end

    def notes
      SortedSet.new mapping.values
    end

    def available_notes
      SortedSet.new available_mapping.values
    end

    def missing_notes
      SortedSet.new(notes) - SortedSet.new(available_notes)
    end
  end

  def match_notes(match_notes)
    match_notes_uniq_sort = match_notes.uniq.sort
    lowest_tune_note, normalized_tune_semitones = Note.normalize_to_semitones uniq_notes

    best_version = nil

    matches = (0 .. match_notes_uniq_sort.size).collect do |match_note_offset|
      remaining_match_notes = match_notes_uniq_sort.from match_note_offset

      lowest_match_note, normalized_remaining_semitones = Note.normalize_to_semitones remaining_match_notes
      intersection = normalized_tune_semitones & normalized_remaining_semitones

      is_full_match = intersection.size == normalized_tune_semitones.size
      is_best_match = best_version.nil? || intersection.size > best_version.available_mapping.size

      next nil unless is_full_match || is_best_match

      mapping = uniq_notes.sort.map do |tune_note|
        offset = lowest_match_note.semitone - lowest_tune_note.semitone
        match_note = Note.new tune_note.semitone + offset
        [tune_note, match_note]
      end

      mapping = Hash[mapping]
      transposition = transpose mapping
      version = MatchVersion.new mapping, transposition
      best_version = version if is_best_match

      is_full_match ? version : nil
    end

    MatchResult.new best_version, matches.compact
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

  def self.parse_lyrics(input)
    unless input.kind_of? Array
      input = input.split ','
    end

    input.map { |l| l.strip }
  end

end
