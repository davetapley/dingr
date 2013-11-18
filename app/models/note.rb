class Note

  include Comparable

  # Stores note as semitone offset from middle C, see:
  # http://en.wikipedia.org/wiki/Scientific_pitch_notation#Table_of_note_frequencies

  attr_reader :semitone

  def self.parse(input)
    Note.new(*input.match(/([a-gA-G])(#?)(\d?)/).captures)
  end

  def self.normalize_to_semitones(notes)
    sorted_set = SortedSet.new notes.map(&:semitone)
    key_offset = Note.new sorted_set.first
    normalized = sorted_set.map { |n| n - key_offset.semitone }
    [key_offset, normalized]
  end

  def initialize(*args)
    @semitone = args.length == 1 ? args.first : to_semitone(*args)
  end

  def hash
    semitone.hash
  end

  alias eql? ==

  def <=>(o)
    semitone <=> o.semitone
  end

  def letter
    case @semitone % 12
    when 0, 1
      :c
    when 2, 3
      :d
    when 4
      :e
    when 5, 6
      :f
    when 7, 8
      :g
    when 9, 10
      :a
    when 11
      :b
    end
  end

  def accidental
    [0, 2, 4, 5, 7, 9, 11].include?(@semitone % 12) ? nil : :sharp
  end

  def octave
    (@semitone / 12) + 4
  end

  def to_s
    "#{ letter.to_s.upcase }#{ accidental == :sharp ? '#' : '' }#{ octave }"
  end

  private

  def to_semitone(letter, accidental, octave)
    semitone = case letter.downcase.to_sym
               when :c
                 0
               when :d
                 2
               when :e
                 4
               when :f
                 5
               when :g
                 7
               when :a
                 9
               when :b
                 11
               end

    semitone += 1 if [:sharp, '#'].include? accidental

    octave = octave.present? ? octave.to_i : 4
    semitone += (octave - 4) * 12
    semitone
  end

end
