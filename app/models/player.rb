class Player < ActiveRecord::Base

  def self.notes
    pluck('DISTINCT(unnest(semitones))').collect do |s|
      Note.new s.to_i
    end
  end

  def self.parse(input)
    Tune.new notes: input.split(' ').map { |n| Note.parse n }
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

end
