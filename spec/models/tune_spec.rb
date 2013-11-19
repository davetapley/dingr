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

    let(:sample_tune) { 'A4 B4 C#4' }

    it 'are converted to semitones and back' do
      tune = Tune.parse sample_tune
      expect(tune.notes.length).to eq 3

      expect(tune.notes.first.letter).to eq :a
      expect(tune.notes.first.semitone).to eq 9

      expect(tune.notes.last.letter).to eq :c
      expect(tune.notes.last.semitone).to eq 1
    end
  end

  describe 'match_notes' do

    describe 'sample tune' do

      let(:sample_tune) { Tune.parse 'A4 B4 C#4' }
      let(:best_match_count) { sample_tune.match_notes(notes)[:best_match_count] }
      let(:matches) { sample_tune.match_notes(notes)[:matches] }

      context 'not enough match notes for tune' do
        let(:notes) { [Note.new(0)] }
        it { expect(best_match_count).to eq 1 }
        it { expect(matches).to be_empty }
      end

      context 'not enough unique match notes for tune' do
        let(:notes) { [Note.new(4), Note.new(0), Note.new(4)] }
        it { expect(best_match_count).to eq 1 }
        it { expect(matches).to be_empty }
      end

      context 'exact match' do
        let(:notes) { sample_tune.notes }

        it { expect(best_match_count).to eq notes.size }

        it 'only finds the one match' do
          expect(matches).to have(1).item
        end

        it 'uses all the match notes' do
          expect(matches.first.keys).to match_array(notes)
          expect(matches.first.values).to match_array(notes)
        end
      end

      context 'match with extra notes' do
        let(:notes) { sample_tune.notes + [Note.new(0), Note.new(4)] }

        it { expect(best_match_count).to eq sample_tune.notes.size }

        it 'only finds the one match' do
          expect(matches).to have(1).item
        end

        it 'uses all only the sample tune notes' do
          expect(matches.first.keys).to match_array(sample_tune.notes)
          expect(matches.first.values).to match_array(sample_tune.notes)
        end
      end

      context 'match a semitone up' do
        let(:tune_semitone_up) { sample_tune.notes.map { |n| Note.new(n.semitone + 1) } }
        let(:notes) { tune_semitone_up }

        it { expect(best_match_count).to eq sample_tune.notes.size }

        it 'only finds the one match' do
          expect(matches).to have(1).item
        end

        it 'uses all the match notes' do
          expect(matches.first.values).to match_array(tune_semitone_up)
        end

        context 'with extra notes' do
          let(:notes) { tune_semitone_up + [Note.new(0), Note.new(4)] }

          it { expect(best_match_count).to eq sample_tune.notes.size }

          it 'only finds the one match' do
            expect(matches).to have(1).item
          end

          it 'uses all the match notes' do
            expect(matches.first.values).to match_array(tune_semitone_up)
          end
        end
      end


    end

  end

end
