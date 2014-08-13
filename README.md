# Blinkbox::CommonLogging

Automatic configuration for logging in the blinkbox format.

## Usage

```ruby
# $ gem install blinkbox-common_logging
require "blinkbox/common_logging"

log_server = {
  host: "127.0.0.1",
  port: 12201,
  # This is the name of the invoked script
  facility: $0,

}
# These are the defaults

logger = Blinkbox::CommonLogging.new(log_server)

# Usual levels are available
logger.debug "This is a basic debug message"
logger.info  "This is a basic info message"
logger.warn  "This is a basic warn message"
logger.error "This is a basic error message"
logger.fatal "This is a basic fatal message"

# You can also pass an exception to #notify
begin
  "raise an exception".by_calling_a_missing_method
raise StandardError => e
  logger.notify(e)
end
```