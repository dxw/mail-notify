[![CircleCI](https://circleci.com/gh/pezholio/mail-notify.svg?style=svg)](https://circleci.com/gh/pezholio/mail-notify)

# Mail::Notify

Rails / ActionMailer support for the [GOV.UK Notify API](https://www.notifications.service.gov.uk).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mail-notify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mail-notify

Then, add the following to your `config/environments/*.rb` (where * is `test`, `development`, `production` or 
whatever other environment(s) you have) file(s):

```ruby
config.action_mailer.delivery_method = :notify
config.action_mailer.notify_settings = {
  api_key: YOUR_NOTIFY_API_KEY
}
```

## Usage

This gem assumes you have a very simple template set up in Notify, with a `((subject))` variable
in the subject line, and a `((body))` variable in the body field, as below:

![Example screenshot](docs/screenshot.png)

Support for further customisations may come further down the road.

### Mailers

When using mailers, instead of inheriting from `ActionMailer::Base`, you'll need to inherit from `Mail::Notify::ViewMailer`, and instead of calling `mail` with a hash of email headers, you'll need to call `notify_mail` with the first parameter being the ID of the notify template, followed by a hash of email headers e.g:

```ruby
class MyMailer < Mail::Notify::ViewMailer
    def send_email
        notify_mail('YOUR_TEMPLATE_ID_GOES_HERE',
          to: 'mail@somewhere.com',
          subject: 'Subject line goes here'
        )
    end
end
```

### Views

Views should be simple `text.erb` files. You can add some markdown for headers, bullet points and links etc. These are handled in the same way as standard action_mailer views.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mail-notify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mail::Notify project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/mail-notify/blob/master/CODE_OF_CONDUCT.md).
