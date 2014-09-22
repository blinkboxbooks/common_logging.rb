# Change log

## 0.3.1 ([#4](https://git.mobcastdev.com/Platform/common_logging.rb/pull/4) 2014-09-22 13:53:00)

Ensure from_config actually works from a config!

### Bugfix

- `.from_config` now expects a shallow hash (with dots in keys) just as common_config.rb provides.

## 0.3.0 ([#3](https://git.mobcastdev.com/Platform/common_logging.rb/pull/3) 2014-08-14 16:45:39)

Allow adding of service version to default params

### New feature

- Allows us to add the default `serviceVersion` parameter to the messages sent to GrayLog which, along with the facility (which should be the service name) will allow us to pinpoint what code needs to be looked at when issues occur.

## 0.2.0 ([#2](https://git.mobcastdev.com/Platform/common_logging.rb/pull/2) 2014-08-14 13:09:41)

Support loading directly from config

### New feature

- Allow the injection of a hash from common_config to initialise a logger.

## 0.1.0 ([#1](https://git.mobcastdev.com/Platform/common_logging.rb/pull/1) 2014-08-12 17:05:06)

First release

### New Features

- Logs messages and exceptions.
- Pretty much only wraps the `GELF::Notifier` class (may need to check log levels) at the moment, but we may extend this to include extra functionality as the ruby logging requirements become clear.

