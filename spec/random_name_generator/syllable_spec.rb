# frozen_string_literal: true

RSpec.describe RandomNameGenerator::Syllable do
  context "with flags" do
    context "with prefix?" do
      ["-an", "-ang +v", "  -ansr +v", "-cael   ", "-dae +c"].each do |s|
        it "returns true when '#{s}' is marked as a prefix" do
          expect(described_class.new(s).prefix?).to be true
        end
      end

      ["que -v +c", "ria", "rail", "ther", "thus", "thi", "san", "+ael -c"].each do |s|
        it "returns false when '#{s}' is marked as a prefix" do
          expect(described_class.new(s).prefix?).to be false
        end
      end
    end

    context "with suffix?" do
      ["+ath", " +ess", "+san", "+yth  ", "+las", "+lian", "+evar"].each do |s|
        it "returns true when '#{s}' is marked as a suffix" do
          expect(described_class.new(s).suffix?).to be true
        end
      end

      ["-que -v +c", "ria", "rail", "ther", "thus", "thi", "san", "ael -c"].each do |s|
        it "returns false when '#{s}' is marked as a suffix" do
          expect(described_class.new(s).suffix?).to be false
        end
      end
    end

    context "with next_syllable_must_start_with_vowel?" do
      ["-ang +v", "-ansr +v -c"].each do |s|
        it "returns true when '#{s}' syllable has a +v must start with a vowel flag" do
          expect(described_class.new(s).next_syllable_must_start_with_vowel?).to be true
        end
      end

      ["-ang -v", "-ansr -v +c", "-yada"].each do |s|
        it "returns false when '#{s}' syllable does not have a +v must start with a vowel flag" do
          expect(described_class.new(s).next_syllable_must_start_with_vowel?).to be false
        end
      end
    end

    context "with next_syllable_must_start_with_consonant?" do
      ["-ang +c", "-ansr -v +c"].each do |s|
        it "returns true when '#{s}' syllable has a +c must start with a consonant flag" do
          expect(described_class.new(s).next_syllable_must_start_with_consonant?).to be true
        end
      end

      ["-ang -v", "-ansr -v -c", "-yada"].each do |s|
        it "returns false when '#{s}' syllable does not have a +c next must start with a consonant flag" do
          expect(described_class.new(s).next_syllable_must_start_with_consonant?).to be false
        end
      end
    end

    context "with previous_syllable_must_end_with_vowel?" do
      ["-ang -v", "-ansr -v +c"].each do |s|
        it "returns true when '#{s}' syllable has a -v flag" do
          expect(described_class.new(s).previous_syllable_must_end_with_vowel?).to be true
        end
      end

      ["-ang +v", "-ansr +v -c", "-yada"].each do |s|
        it "returns false when '#{s}' syllable does not have a -v flag" do
          expect(described_class.new(s).previous_syllable_must_end_with_vowel?).to be false
        end
      end
    end

    context "with previous_syllable_must_end_with_consonant?" do
      ["-ang -c", "-ansr +v -c"].each do |s|
        it "returns true when '#{s}' syllable has a -c flag" do
          expect(described_class.new(s).previous_syllable_must_end_with_consonant?).to be true
        end
      end

      ["-ang +v", "-ansr -v +c", "-yada"].each do |s|
        it "returns false when '#{s}' syllable has not have a -c flag" do
          expect(described_class.new(s).previous_syllable_must_end_with_consonant?).to be false
        end
      end
    end

    context "with consonant_first?" do
      ["-ng -c", "-sr +v -c", "-yada"].each do |s|
        it "returns true when '#{s}' starts with a consonant" do
          expect(described_class.new(s).consonant_first?).to be true
        end
      end

      ["-ang +v", "-ansr -v +c"].each do |s|
        it "returns false when '#{s}' starts with a vowel" do
          expect(described_class.new(s).consonant_first?).to be false
        end
      end
    end

    context "when vowel_first?" do
      ["-ang +v", "-ansr -v +c", "-yada"].each do |s|
        it "returns true when '#{s} starts with a vowel" do
          expect(described_class.new(s).vowel_first?).to be true
        end
      end

      ["-ng -c", "-sr +v -c"].each do |s|
        it "returns false when '#{s}' starts with a consonant" do
          expect(described_class.new(s).vowel_first?).to be false
        end
      end
    end

    context "with consonant_last?" do
      ["-ng -c", "-sr +v -c", "-ansr"].each do |s|
        it "returns true when '#{s}' ends with a consonant" do
          expect(described_class.new(s).consonant_last?).to be true
        end
      end

      ["-yada", "ria -c", "thi"].each do |s|
        it "returns false when '#{s}' ends with a vowel" do
          expect(described_class.new(s).consonant_last?).to be false
        end
      end
    end

    context "with vowel_last?" do
      ["-yada", "ria +c", "thi"].each do |s|
        it "returns true when '#{s}' ends with a vowel" do
          expect(described_class.new(s).vowel_last?).to be true
        end
      end

      ["-kan", "+emar", "+nes", "+nin", "dul", "ean -c", "el", "emar"].each do |s|
        it "returns false when '#{s}' ends with a consonant" do
          expect(described_class.new(s).vowel_last?).to be false
        end
      end
    end
  end

  context "with compatibility" do
    context "when initialize" do
      it "strips the syllable" do
        expect(described_class.new(" a  \n").syllable).to eq("a")
      end

      it "strips the raw value" do
        expect(described_class.new(" a -c +v \n").raw).to eq("a -c +v")
      end

      context "when the values don't need to be stripped" do
        it "preserves the values for a simple syllable if they don't need to be stripped" do
          expect(described_class.new("a").syllable).to eq("a")
        end

        it "preserves the values got a complex syllable if they don't need to be stripped" do
          expect(described_class.new("a -c +v").raw).to eq("a -c +v")
        end
      end
    end

    context "when compatible" do
      [%w[yada ria], ["ae +c -c", "lean"], ["lean -c", "ae +c -c"]].each do |a_b|
        it "incompatible? must return false between #{a_b[0]} and #{a_b[1]}" do
          from = described_class.new(a_b[0])
          to = described_class.new(a_b[1])
          expect(from.incompatible?(to)).to be false
        end

        it "compatible? must return true between #{a_b[0]} and #{a_b[1]}" do
          from = described_class.new(a_b[0])
          to = described_class.new(a_b[1])
          expect(from.compatible?(to)).to be true
        end
      end

      context "when incompatible" do
        [["ria", "lean -c"], ["ae +c -c", "lean -c"], ["at", "la -v"], ["rail", "que -v +c"], ["ae +c -c", "ael -c"], ["ria", "ael -c"]].each do |a_b|
          it "incompatible? must return true between #{a_b[0]} and #{a_b[1]}" do
            from = described_class.new(a_b[0])
            to = described_class.new(a_b[1])
            expect(from.incompatible?(to)).to be true
          end

          it "compatible? must return false between #{a_b[0]} and #{a_b[1]}" do
            from = described_class.new(a_b[0])
            to = described_class.new(a_b[1])
            expect(from.compatible?(to)).to be false
          end
        end
      end
    end
  end
end
