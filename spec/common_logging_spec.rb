context Blinkbox::CommonLogging do
  describe "logger interface" do
    before :each do
      fake_class = class_double("GELF::RubyUdpSender")
      stub_const("GELF::RubyUdpSender", fake_class)
      @fake = instance_double("GELF::RubyUdpSender")
      allow(fake_class).to receive(:new).and_return(@fake)
      allow(@fake).to receive(:send_datagrams)
    end

    subject(:logger) { described_class.new }

    %i{debug info warn error fatal}.each do |level|
      it "must deliver #{level} level string messages to GrayLog" do
        log_string = "Test #{level} string"
        logger.send(level, log_string)
        
        log_hash = expected_hash({
          short_message: log_string,
          level: GELF.const_get(level.to_s.upcase)
        })
        expect(GELF::Notifier.last_hash).to eq(log_hash)
      end
    end

    it "must log exceptions at the error level" do
      begin
        raise RuntimeError, "Something went wrong"
      rescue RuntimeError => e
      end
      logger.notify e

      log_hash = expected_hash({
        short_message: "#{e.class}: #{e.message}",
        level: GELF::ERROR,
        full_message: "Backtrace:\n#{e.backtrace.join("\n")}"
      })
      expect(GELF::Notifier.last_hash).to eq(log_hash)
    end
  end

  describe "#from_config" do
    it "must accept the logger tree from a config file" do
      config = {
        :level               => "INFO",
        :'udp.host'          => "127.0.0.2",
        :'udp.port'          => 12345,
        :'gelf.facility'     => "my_facility",
        :'gelf.maxChunkSize' => 8100
      }
      logger = described_class.from_config(config)
      
      expect(logger.host).to eq(config[:'udp.host'])
      expect(logger.port).to eq(config[:'udp.port'])
      expect(logger.default_options["facility"]).to eq(config[:'gelf.facility'])
      expect(logger.max_chunk_size).to eq(config[:'gelf.maxChunkSize'])
      expect(logger.level).to eq(GELF.const_get(config[:level].upcase))
    end

    it "must raise an ArgumentError if any settings are invalid, listing problem values" do
      config = {
        :level               => "INFO",
        :'udp.host'          => "127.0.0.2",
        :'udp.port'          => 12345,
        :'gelf.facility'     => "my_facility",
        :'gelf.maxChunkSize' => 8100
      }

      %i{udp.host udp.port gelf.facility gelf.maxChunkSize}.each do |invalid_config|
        begin
          partially_invalid_config = config.dup
          partially_invalid_config[invalid_config] = nil
          described_class.from_config(partially_invalid_config)
          expect("this").to_not be("reached"), "#from_config didn't raise an ArgumentError"
        rescue ArgumentError => e
          expect(e.message).to include(invalid_config.to_s)
        end
      end
    end
  end
end