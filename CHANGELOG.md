# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog]

## [Unreleased]

- Fixed a bug in `view_mail` and `template_mail` that meant the options were being
  included in the preview email headers for no reason - thanks to @inulty-dfe
- Fixed a bug in `view_mail` that meant custom headers in the preview email were
  duplicated - thanks to @inulty-dfe

## [2.0.0] - 2024-04-01

- Version 2.0.0 rewrites most of the gem, without altering the API
- The gem no longer prepends code in ActionMailer
- Previews are now 100% supported in Rails, but will require a Notify API key
- The preview layout has been updated and uses the Tudor Crown
- This version fixes a bug that meant not all Rails preview functionality would
  work
- This version fixes a bug that meant no Rails preview functionality would work
  from version 7.1.0 onwards

## [1.2.0] - 2023-04-28

- Requiring Ruby 2.7.8
- Specs now support Ruby 3.x
- Development now uses Rails 7.x

## [1.1.0] - 2022-09-09

- Revert previous Zeitwerk fix
- Specifically require `rails/mailers_controller` in the Railtie

## [1.0.5] - 2022-08-31

- Allow explicitly blank personalisations (https://github.com/dxw/mail-notify/pull/30)
- Fix Zeitwerk compatibility issue (https://github.com/dxw/mail-notify/pull/58)
- Dependency updates

## [1.0.4] - 2021-01-28

- Remove pessimistic constraint on Rails version

## [1.0.3] - 2020-12-14

- Add support for ActionMailer 6.1

## [1.0.2] - 2020-03-24

- Add support for ActionMailer 6.0

## [1.0.1] - 2020-03-06

- Support additional Notify services

## [1.0] - 2019-10-22

- Bump Notify gem to 5.1
- Add error handling for blank variables

## [0.2.1] - 2019-10-22

- Add Rails 6 support for previews
- Add GOV.UK Notify styling to preview emails

## [0.2.0] - 2019-08-30

- Add Rails 6 support
- Add optional `reply_to_id` and `reference` parameters

## [0.1.0] - 2019-05-07

- Add preview functionality

## [0.0.3] - 2019-02-05

- Allow response to be accessed

## [0.0.2] - 2019-02-01

- Support templated emails
- Change API so mailers inherit from our mailer

## [0.0.1] - 2019-02-01

- Initial release

[unreleased]: https://github.com/dxw/mail-notify/compare/2.0.0...HEAD
[2.0.0]: https://github.com/dxw/mail-notify/compare/1.2.0...2.0.0 
[1.2.0]: https://github.com/dxw/mail-notify/compare/1.1.0...1.2.0 
[1.1.0]: https://github.com/dxw/mail-notify/compare/1.0.5...1.1.0 
[1.0.5]: https://github.com/dxw/mail-notify/compare/1.0.4...1.0.5
[1.0.4]: https://github.com/dxw/mail-notify/compare/1.0.3...1.0.4
[1.0.3]: https://github.com/dxw/mail-notify/compare/1.0.2...1.0.3
[1.0.2]: https://github.com/dxw/mail-notify/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/dxw/mail-notify/compare/1.0...1.0.1
[1.0]: https://github.com/dxw/mail-notify/compare/0.2.1...1.0
[0.2.1]: https://github.com/dxw/mail-notify/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/dxw/mail-notify/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/dxw/mail-notify/compare/0.0.3...0.1.0
[0.0.3]: https://github.com/dxw/mail-notify/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/dxw/mail-notify/compare/0.0.1...0.0.2
[0.0.2]: https://github.com/dxw/mail-notify/compare/0.0.1...0.0.2
[0.0.1]: https://github.com/dxw/mail-notify/compare/fdc830bbbc29df5998a49bf2920e23d1be6ac5e7...0.0.1
[keep a changelog]: https://keepachangelog.com/en/1.0.0/
