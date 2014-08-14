require "gelf"

module Blinkbox
  class CommonLogging < GELF::Logger
    def initialize(host: "localhost", port: 12201, facility: $0, max_size: 8192, facility_version: nil)
      options = { facility: facility }
      options[:facilityVersion] = facility_version unless facility_version.nil?
      super(host, port, max_size, options)
    end

    def facility_version=(semver)
      self.default_options['facilityVersion'] = semver
    end

    def self.from_config(hash)
      logger = new(
        host: hash["udp"]["host"],
        port: hash["udp"]["port"],
        facility: hash["gelf"]["facility"],
        max_size: hash["gelf"]['maxChunkSize']
      )
      logger.level = GELF.const_get(hash["level"].upcase)
      logger
    end
  end
end