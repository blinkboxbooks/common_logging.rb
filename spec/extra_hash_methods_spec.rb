require "blinkbox/utilities/extra_hash_methods"

context Blinkbox::ExtraHashMethods do
  describe "#flatten_hash" do
    it "must reduce a two level deep hash" do
      hash = {
        'firstA' => {
          'second' => "firstA.second"
        },
        'firstB' => "firstB"
      }

      output = hash.extend(described_class).shallow!

      expect(output).to eql(true)
      hash.each do |key, value|
        expect(key).to eq(value)
      end
    end

    it "must reduce a two level deep hash with symbol keys" do
      hash = {
        firstA: {
          second: "firstA.second"
        },
        firstB: :firstB
      }

      output = hash.extend(described_class).shallow!

      expect(output).to eql(true)
      hash.each do |key, value|
        expect(key).to eq(value)
      end
    end

    it "must not change a shallow hash" do
      hash = {
        'firstA' => "firstA",
        'firstB' => "firstB"
      }

      output = hash.extend(described_class).shallow!

      expect(output).to eql(false)
      hash.each do |key, value|
        expect(key).to eq(value)
      end
    end

    it "must allow joining with other strings" do
      hash = {
        'firstA' => {
          'second' => "firstA-second"
        },
        'firstB' => "firstB"
      }

      output = hash.extend(described_class).shallow!('-')

      expect(output).to eql(true)
      hash.each do |key, value|
        expect(key).to eq(value)
      end
    end

    it "must output clashing keys" do
      hash = {
        'firstA' => {
          'second' => "firstA.second"
        },
        'firstA.second' => "overwritten"
      }

      output = hash.extend(described_class).shallow!
      expect(output).to eql(["firstA.second"])
    end

    it "must reduce a three level deep hash" do
      hash = {
        'firstA' => {
          'secondA' => {
            'third' => "firstA.secondA.third"
          },
          'secondB' => "firstA.secondB"
        },
        'firstB' => "firstB"
      }

      expected = {
        'firstA.secondA.third' => "firstA.secondA.third",
        'firstA.secondB' => "firstA.secondB",
        'firstB' => "firstB"
      }

      output = hash.extend(described_class).shallow!

      expect(hash).to eql(expected)
    end
  end
end