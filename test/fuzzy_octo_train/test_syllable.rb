require 'minitest/autorun'
require 'fuzzy_octo_train/syllable'

describe Syllable do
  describe 'considering is_prefix?' do
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

  describe 'considering is_suffix?' do
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
end
