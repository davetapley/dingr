# encoding: utf-8

class Rest < Crotchet

  def to_s(format = :human)
    format == :db ? 'r' : '𝄽'
  end

  def to_midi
    'r'
  end

end
