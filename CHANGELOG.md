# Change log

## 0.2.0 ([#2](https://git.mobcastdev.com/Platform/common_logging.rb/pull/2) 2014-08-14 13:09:41)

Support loading directly from config

### New feature

- Allow the injection of a hash from common_config to initialise a logger.

## 0.1.0 ([#1](https://git.mobcastdev.com/Platform/common_logging.rb/pull/1) 2014-08-12 17:05:06)

First release

### New Features

- Logs messages and exceptions.
- Pretty much only wraps the `GELF::Notifier` class (may need to check log levels) at the moment, but we may extend this to include extra functionality as the ruby logging requirements become clear.

