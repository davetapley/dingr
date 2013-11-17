class Tune < ActiveRecord::Base

  def self.parse(input)
    Tune.new notes: input.split(',').map { |n| Note.parse n.strip }
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

end
