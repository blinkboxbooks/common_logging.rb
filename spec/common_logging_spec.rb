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
end