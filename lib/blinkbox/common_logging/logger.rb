require "gelf"
require "logger"

module Blinkbox
  class CommonLogging < GELF::Logger
    def initialize(host: "localhost", port: 12201, facility: $0, max_size: 8192, facility_version: nil, echo_to_console: false)
      validity_issues = []
      validity_issues.push("host") unless host.is_a?(String)
      validity_issues.push("port") unless port.is_a?(Integer)
      validity_issues.push("facility") unless facility.is_a?(String)
      validity_issues.push("max_size") unless max_size.is_a?(Integer)
      raise ArgumentError, "Cannot start the logger, the following settings weren't valid: #{validity_issues.join(", ")}" if !validity_issues.empty?

      if echo_to_console
        @stdout_logger = Logger.new(STDOUT)
        @stdout_logger.formatter = proc do |severity, datetime, progname, msg|
          # Using console output is only for live-debug, so we can strip the timestamp, progname
          l = msg.dup
          l.delete("facility")
          l.delete(:facility)
          log_msg = "#{severity[0..0]} #{l.delete("short_message")}#{l.delete(:short_message)}"
          log_msg << " (#{l})" if l.any?
          log_msg << "\n"
          log_msg
        end
      end
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
      mapping = {
        host:            :'udp.host',
        port:            :'udp.port',
        facility:        :'gelf.facility',
        max_size:        :'gelf.maxChunkSize',
        echo_to_console: :'console.enabled'
      }
      begin
        logger = new(Hash[mapping.map { |k, v| [k, hash[v]] }])
      rescue ArgumentError => e
        msg = e.message
        mapping.each do |k, v|
          msg.sub!(k.to_s, v.to_s)
        end
        raise e.class, msg
      end
      logger.level = GELF.const_get(hash[:level].upcase) rescue GELF::INFO
      logger
    end

    private
    def notify_with_level!(message_level, msg)
      if @stdout_logger
        level = GELF::Levels.constants[message_level].to_s.downcase.to_sym
        @stdout_logger.send(level, msg)
      end
      msg.extend(ExtraHashMethods).shallow! if msg.is_a?(Hash)
      super(message_level, msg)
    end
  end
end