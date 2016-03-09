require 'minitest/autorun'
require 'fuzzy_octo_train/syllable'

include FuzzyOctoTrain

describe Syllable do
  describe 'considering prefix?' do
    describe 'when marked as a prefix' do
      ['-an', '-ang +v', '-ansr +v', '-cael', '-dae +c'].each do |s|
        it 'is_prefix? must return true' do
          assert Syllable.new(s).prefix?
        end
      end
    end

    describe 'when not marked as a prefix' do
      ['que -v +c', 'ria', 'rail', 'ther', 'thus', 'thi', 'san', '+ael -c'].each do |s|
        it 'is_prefix? must return false' do
          refute Syllable.new(s).prefix?
        end
      end
    end
  end

  describe 'considering suffix?' do
    describe 'when marked as a suffix' do
      ['+ath', '+ess', '+san', '+yth', '+las', '+lian', '+evar'].each do |s|
        it 'is_suffix? must return true' do
          assert Syllable.new(s).suffix?
        end
      end
    end

    describe 'when not marked as a suffix' do
      ['-que -v +c', 'ria', 'rail', 'ther', 'thus', 'thi', 'san', 'ael -c'].each do |s|
        it 'is_suffix? must return false' do
          refute Syllable.new(s).suffix?
        end
      end
    end
  end

  describe 'considering next_syllable_must_start_with_vowel?' do
    describe 'when marked true (+v)' do
      ['-ang +v', '-ansr +v -c'].each do |s|
        it 'next_syllable_must_start_with_vowel? must return true' do
          assert Syllable.new(s).next_syllable_must_start_with_vowel?
        end
      end
    end
    describe 'when marked false' do
      ['-ang -v', '-ansr -v +c', '-yada'].each do |s|
        it 'next_syllable_must_start_with_vowel? must return false' do
          refute Syllable.new(s).next_syllable_must_start_with_vowel?
        end
      end
    end
  end

  describe 'considering next_syllable_must_start_with_consonant?' do
    describe 'when marked true (+c)' do
      ['-ang +c', '-ansr -v +c'].each do |s|
        it 'next_syllable_must_start_with_consonant? must return true' do
          assert Syllable.new(s).next_syllable_must_start_with_consonant?
        end
      end
    end
    describe 'when marked false' do
      ['-ang -v', '-ansr -v -c', '-yada'].each do |s|
        it 'next_syllable_must_start_with_consonant? must return false' do
          refute Syllable.new(s).next_syllable_must_start_with_consonant?
        end
      end
    end
  end

  describe 'considering previous_syllable_must_end_with_vowel?' do
    describe 'when marked true (-v)' do
      ['-ang -v', '-ansr -v +c'].each do |s|
        it 'previous_syllable_must_end_with_vowel? must return true' do
          assert Syllable.new(s).previous_syllable_must_end_with_vowel?
        end
      end
    end
    describe 'when marked false' do
      ['-ang +v', '-ansr +v -c', '-yada'].each do |s|
        it 'previous_syllable_must_end_with_vowel? must return false' do
          refute Syllable.new(s).previous_syllable_must_end_with_vowel?
        end
      end
    end
  end

  describe 'considering previous_syllable_must_end_with_consonant?' do
    describe 'when marked true (-v)' do
      ['-ang -c', '-ansr +v -c'].each do |s|
        it 'previous_syllable_must_end_with_consonant? must return true' do
          assert Syllable.new(s).previous_syllable_must_end_with_consonant?
        end
      end
    end
    describe 'when marked false' do
      ['-ang +v', '-ansr -v +c', '-yada'].each do |s|
        it 'previous_syllable_must_end_with_consonant? must return false' do
          refute Syllable.new(s).previous_syllable_must_end_with_consonant?
        end
      end
    end
  end
end
