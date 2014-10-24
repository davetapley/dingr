require 'spec_helper'

describe Player do

  describe 'notes' do

    let(:sample_notes) { ['A4', 'B4', 'C#4'].collect { |n| Note.parse n } }

    it 'are converted to semitones and back' do
      player = Player.create notes: sample_notes
      expect(player.notes.length).to eq 3

      expect(player.notes.first.letter).to eq :a
      expect(player.notes.first.semitone).to eq 9

      expect(player.notes.last.letter).to eq :c
      expect(player.notes.last.semitone).to eq 1
    end

  end

  describe 'parse' do

    let(:sample_notes) { 'A4 B4 C#4' }

    it 'are converted to semitones and back' do
      player = Player.parse sample_notes
      expect(player.crotchets.length).to eq 3

      expect(player.crotchets.first.letter).to eq :a
      expect(player.crotchets.first.semitone).to eq 9

      expect(player.crotchets.last.letter).to eq :c
      expect(player.crotchets.last.semitone).to eq 1
    end
  end

end
