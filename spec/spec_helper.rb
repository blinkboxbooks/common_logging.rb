$LOAD_PATH.unshift File.join(__dir__, "../lib")
require "blinkbox/common_logging"
require "rspec/mocks"

module Helpers
  def expected_hash(hash)
    n = Blinkbox::CommonLogging.new
    n.send(:extract_hash, hash)
    n.send(:serialize_hash)
    hash = n.instance_variable_get(:'@hash')

    # The following will be different in test code, so we just ignore them
    hash.delete_if { |key, v| %w{timestamp line file}.include?(key) }
  end
end

class GELF::Notifier
  def self.last_hash
    # The following will be different in test code, so we just ignore them
    @@last_hash.delete_if { |key, v| %w{timestamp line file}.include?(key) }
  end

  private
  alias :old_serialize_hash :serialize_hash
  def serialize_hash
    @@last_hash = @hash
    old_serialize_hash
  end
end

RSpec.configure do |c|
  c.include Helpers
end