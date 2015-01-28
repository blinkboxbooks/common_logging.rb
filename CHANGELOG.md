# Change log

## Open Source release (2015-01-28 14:11:21)

Today we have decided to publish parts of our codebase on Github under the [MIT licence](LICENCE). The licence is very permissive, but we will always appreciate hearing if and where our work is used!

## 0.5.1 ([#8](https://git.mobcastdev.com/Platform/common_logging.rb/pull/8) 2014-12-15 15:01:11)

Changed level mapping to :direct

### Bug fixes

- Changed the level mapping to be `:direct` which means that
`logger.error` causes an error level message in Graylog, `logger.warn`
causes a warning level message, and so on. The default mappings mean
that `logger.error` causes a warning level message, and `logger.warn`
causes a notice level message which is nuts.

## 0.5.0 ([#7](https://git.mobcastdev.com/Platform/common_logging.rb/pull/7) 2014-10-03 15:02:14)

Log to console as well as Graylog

### New features

- Setting `logging.console.enabled` to `true` will now output to stdout as well as graylog.
- Slight refactoring of code in files.

## 0.4.1 ([#6](https://git.mobcastdev.com/Platform/common_logging.rb/pull/6) 2014-10-02 08:31:38)

Validation of values

### Improvements

- Validates input from config and raises an `ArgumentError` if anything is unusable.
- Will list out *all* problematic variables so fixing the config is faster.
- Translates the named invalid keys between `from_config` and `new` so that the error message makes sense for the code being used.

## 0.4.0 ([#5](https://git.mobcastdev.com/Platform/common_logging.rb/pull/5) 2014-09-25 10:46:32)

Shallow hashes

### New feature

- Graylog can't deal with nested hashes, so I've added functionality to flatten deep hashes given to the logging methods into dot-separated shallow ones:

```ruby
{
  a: {
    b: "will become a.b"
  }
}
```

becomes

```ruby
{
  "a.b" => "will become a.b"
}
```

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

