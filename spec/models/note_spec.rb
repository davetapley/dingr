require 'spec_helper'

describe Note do

  describe 'Scientific pitch notation' do

    describe 'from semitone' do

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

    end

    describe 'from string' do

      it 'parses natural without accidental' do
        note = Note.parse 'C4'
        expect(note.letter).to eq :c
        expect(note.accidental).to eq nil
        expect(note.octave).to eq 4
      end

      it 'parses accidental' do
        note = Note.parse 'D#7'
        expect(note.letter).to eq :d
        expect(note.accidental).to eq :sharp
        expect(note.octave).to eq 7
      end

      it 'assumes fourth octave' do
        note = Note.parse 'A#'
        expect(note.letter).to eq :a
        expect(note.accidental).to eq :sharp
        expect(note.octave).to eq 4
      end

    end

  end

end
