require 'spec_helper'

describe Tune do

  describe 'notes' do

    let(:sample_tune) { ['A4', 'B4', 'C#4'].collect { |n| Note.parse n } }

    it 'are converted to semitones and back' do
      tune = Tune.create notes: sample_tune
      expect(tune.notes.length).to eq 3

      expect(tune.notes.first.letter).to eq :a
      expect(tune.notes.first.semitone).to eq 9

      expect(tune.notes.last.letter).to eq :c
      expect(tune.notes.last.semitone).to eq 1
    end

  end

  describe 'parse' do

    let(:sample_tune) { 'A4, B4, C#4' }

    it 'are converted to semitones and back' do
      tune = Tune.parse sample_tune
      expect(tune.notes.length).to eq 3

      expect(tune.notes.first.letter).to eq :a
      expect(tune.notes.first.semitone).to eq 9

      expect(tune.notes.last.letter).to eq :c
      expect(tune.notes.last.semitone).to eq 1
    end
  end

end
