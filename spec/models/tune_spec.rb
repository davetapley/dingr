require 'spec_helper'

describe Tune do

  describe 'crotchets' do

    let(:sample_tune) { ['A4', 'B4', 'C#4'].collect { |n| Note.parse n } }

    it 'are converted to semitones and back' do
      tune = Tune.create crotchets: sample_tune
      expect(tune.crotchets.length).to eq 3

      expect(tune.crotchets.first.letter).to eq :a
      expect(tune.crotchets.first.semitone).to eq 9

      expect(tune.crotchets.last.letter).to eq :c
      expect(tune.crotchets.last.semitone).to eq 1
    end

  end

  describe 'parse' do

    describe 'space separate tune' do
      let(:sample_tune) { 'A4 B4 C#4' }

      it 'are converted to semitones and back' do
        tune = Tune.parse sample_tune
        expect(tune.crotchets.length).to eq 3

        expect(tune.crotchets.first.letter).to eq :a
        expect(tune.crotchets.first.semitone).to eq 9

        expect(tune.crotchets.last.letter).to eq :c
        expect(tune.crotchets.last.semitone).to eq 1
      end
    end

    describe 'comma separate tune' do
      let(:sample_tune) { 'A4, B4,C#4' }

      it 'are converted to semitones and back' do
        tune = Tune.parse sample_tune
        expect(tune.crotchets.length).to eq 3

        expect(tune.crotchets.first.letter).to eq :a
        expect(tune.crotchets.first.semitone).to eq 9

        expect(tune.crotchets.last.letter).to eq :c
        expect(tune.crotchets.last.semitone).to eq 1
      end
    end

    describe 'space separate tune with newlines' do
      let(:sample_tune) { <<-TUNE }
      A4 B4
      C#4
      TUNE

      it 'are converted to semitones and back' do
        tune = Tune.parse sample_tune
        expect(tune.crotchets.length).to eq 3

        expect(tune.crotchets.first.letter).to eq :a
        expect(tune.crotchets.first.semitone).to eq 9

        expect(tune.crotchets.last.letter).to eq :c
        expect(tune.crotchets.last.semitone).to eq 1
      end
    end
  end

  describe 'match_notes' do

    describe 'sample tune' do

      let(:sample_tune) { Tune.parse 'A4 B4 C#4' }
      let(:versions) { sample_tune.match_notes(crotchets).versions }

      context 'not enough match crotchets for tune' do
        let(:crotchets) { [Note.new(0)] }
        it { expect(versions).to be_empty }
      end

      context 'not enough unique match crotchets for tune' do
        let(:crotchets) { [Note.new(4), Note.new(0), Note.new(4)] }
        it { expect(versions).to be_empty }
      end

      context 'exact match' do
        let(:crotchets) { sample_tune.crotchets }

        it 'only finds the one match' do
          expect(versions).to have(1).item
        end

        it 'uses all the match crotchets' do
          expect(versions.first.mapping.keys).to match_array(crotchets)
          expect(versions.first.mapping.values).to match_array(crotchets)
        end
      end

      context 'match with extra crotchets' do
        let(:crotchets) { sample_tune.crotchets + [Note.new(0), Note.new(4)] }

        it 'only finds the one match' do
          expect(versions).to have(1).item
        end

        it 'uses all only the sample tune crotchets' do
          expect(versions.first.mapping.keys).to match_array(sample_tune.crotchets)
          expect(versions.first.mapping.values).to match_array(sample_tune.crotchets)
        end
      end

      context 'match a semitone up' do
        let(:tune_semitone_up) do
          sample_tune.crotchets.map { |n| Note.new(n.semitone + 1) }
        end

        let(:crotchets) { tune_semitone_up }

        it 'only finds the one match' do
          expect(versions).to have(1).item
        end

        it 'uses all the match crotchets' do
          expect(versions.first.mapping.values).to match_array(tune_semitone_up)
        end

        context 'with extra crotchets' do
          let(:crotchets) { tune_semitone_up + [Note.new(0), Note.new(4)] }

          it 'only finds the one match' do
            expect(versions).to have(1).item
          end

          it 'uses all the match crotchets' do
            crotchets = versions.first.mapping.values
            expect(crotchets).to match_array(tune_semitone_up)
          end
        end
      end

    end

  end

  describe 'transpose_to_version' do

    let(:sample_tune) { Tune.parse 'A4, B4, C#4' }

    describe 'to original key' do
      it 'should be the same' do
        version = sample_tune.transpose_to_version Note.parse('A4')
        expect(version.transpose.crotchets).to eql(sample_tune.crotchets)
      end
    end

    describe 'to another key' do
      let(:a_transposition) { Tune.parse 'C5, D5, E4' }

      it 'should have correct notes' do
        version = sample_tune.transpose_to_version a_transposition.key
        expect(version.transpose.crotchets).to eql(a_transposition.crotchets)
      end
    end

  end

end
