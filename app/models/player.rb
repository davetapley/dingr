class Player < ActiveRecord::Base

  default_scope where(available: true)

  def self.notes
    pluck('DISTINCT(unnest(semitones))').collect do |s|
      Note.new s.to_i
    end
  end

  def self.with_note(note)
    note.nil? ? none : where("'#{ note.semitone }' = ANY (semitones)")
  end

  def self.parse(input)
    Tune.new crotchets: input.split(' ').map { |n| Note.parse n }
  end

  def notes=(notes)
    if notes.kind_of? String
      notes = notes.split(' ').map { |n| Note.parse n }
    end

    self.semitones = notes.collect do |n|
      n.semitone
    end
  end

  def notes
    semitones.collect do |s|
      Note.new s.to_i
    end
  end

  def notes_string
    notes.map(&:to_s).join ' '
  end

  alias notes_string= notes=

end
