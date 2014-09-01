require "gelf"

module Blinkbox
  class CommonLogging < GELF::Logger
    def initialize(host: "localhost", port: 12201, facility: $0, max_size: 8192, facility_version: nil)
      options = { facility: facility }
      options[:facilityVersion] = facility_version unless facility_version.nil?
      super(host, port, max_size, options)
    end

    # Allows the setting of the facility version default parameter.
    # @param [String] semver The semantic version of the service which is sending logs
    def facility_version=(semver)
      self.default_options['facilityVersion'] = semver
    end

    # Accepts a hash detailing log config settings in the format used in blinkbox Books
    # config files and returns a CommonLogging object.
    #
    # @example Load from config
    #   config = Blinkbox::CommonConfig.new
    #   logger = Blinkbox::CommonLogging.from_config(config.tree(:logging))
    #
    # @param [Hash] hash The returned hash from CommonConfig#tree
    # @option hash [String] :udp.host (localhost) The Graylog host
    # @option hash [Integer] :udp.port (12201) The Graylog port number
    # @option hash [String] :gelf.facility Organisation/app_name eg. Marvin/cover_processor
    # @option hash [Integer] :gelf.maxChunkSize (8192) The default size for UDP chunks sent to the server.
    # @option hash ["DEBUG","INFO","WARN","ERROR","FATAL"] :level ("INFO") The level below which messages will not be sent to Graylog.
    # @return [CommonLogging]
    def self.from_config(hash)
      logger = new(
        host: hash[:udp][:host],
        port: hash[:udp][:port],
        facility: hash[:gelf][:facility],
        max_size: hash[:gelf][:maxChunkSize]
      )
      logger.level = GELF.const_get(hash[:level].upcase) rescue GELF::INFO
      logger
    end

    def facility_version=(facility_version)
      @facility_version = facility_version
    end
  end
end