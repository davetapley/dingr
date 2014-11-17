require 'spec_helper'

describe Note do

  describe 'Scientific pitch notation' do

    describe 'from crotchet' do

      it 'middle C (C4)' do
        note = Note.new 0
        expect(note.letter).to eq :c
        expect(note.accidental).to eq nil
        expect(note.octave).to eq 4
      end

      it 'C#4' do
        note = Note.new 1
        expect(note.letter).to eq :c
        expect(note.accidental).to eq :sharp
        expect(note.octave).to eq 4
      end

      it 'B3' do
        note = Note.new(-1)
        expect(note.letter).to eq :b
        expect(note.accidental).to eq nil
        expect(note.octave).to eq 3
      end

      it 'A3' do
        note = Note.new(-3)
        expect(note.letter).to eq :a
        expect(note.accidental).to eq nil
        expect(note.octave).to eq 3
      end

      it 'D#7' do
        note = Note.new 39
        expect(note.letter).to eq :d
        expect(note.accidental).to eq :sharp
        expect(note.octave).to eq 7
      end

    end

    describe 'to semitone' do

      it 'middle C (C4)' do
        note = Note.new 'C', nil, 4
        expect(note.semitone).to eq 0
      end

      it 'C#4' do
        note = Note.new 'C', :sharp, 4
        expect(note.semitone).to eq 1
      end

      it 'B3' do
        note = Note.new :b, nil, 3
        expect(note.semitone).to eq(-1)
      end

      it 'A3' do
        note = Note.new 'a', nil, 3
        expect(note.semitone).to eq(-3)
      end

      it 'D#7' do
        note = Note.new :d, :sharp, 7
        expect(note.semitone).to eq 39
      end

      it 'Eb3' do
        note = Note.new :e, :flat, 3
        expect(note.semitone).to eq(-9)
      end

    end

    describe 'from string' do

      it 'parses natural without accidental' do
        note = Note.parse 'C4'
        expect(note.letter).to eq :c
        expect(note.accidental).to eq nil
        expect(note.octave).to eq 4
      end

      it 'parses sharp accidental' do
        note = Note.parse 'D#7'
        expect(note.letter).to eq :d
        expect(note.accidental).to eq :sharp
        expect(note.octave).to eq 7
      end

      it 'parses flat accidental' do
        note = Note.parse 'Eb3'
        expect(note.letter).to eq :d
        expect(note.accidental).to eq :sharp
        expect(note.octave).to eq 3
      end

      it 'assumes fourth octave' do
        note = Note.parse 'A#'
        expect(note.letter).to eq :a
        expect(note.accidental).to eq :sharp
        expect(note.octave).to eq 4
      end

    end

  end

  describe 'normalize_to_crotchets' do

    let(:sample_tune) { Tune.parse 'D#8 A#7 C8 D8 C8' }
    let(:normalized) { Note.normalize_to_semitones sample_tune.crotchets }

    it 'returns lowest note' do
      expect(normalized.first).to eq Note.parse('A#7')
    end

    it 'returns normalized crotchets' do
      expect(normalized.last).to eq [0, 2, 4, 5]
    end

  end

end
