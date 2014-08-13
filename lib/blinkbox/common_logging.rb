require "gelf"

module Blinkbox
  class CommonLogging < GELF::Logger
    def initialize(host: "localhost", port: 12201, facility: $0, max_size: 'WAN')
      super(host, port, max_size, { facility: facility })
    end
  end
end