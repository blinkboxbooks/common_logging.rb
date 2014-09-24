require "blinkbox/extra_hash_methods"

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
  end
end