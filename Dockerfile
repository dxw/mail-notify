# We want to support older Rubies
ARG RUBY_VERSION=2.7.8
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Build stage
FROM base AS build

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git

# Install Nokigiri version that supports Ruby 2.7.8
RUN gem install nokogiri -v 1.15.6

# Install Rails
ARG RAILS_VERSION=7.1.3.2
RUN gem install rails -v ${RAILS_VERSION}

# create empty Rails application, we don't need ActiveRecord or JavaScript
RUN rails new mail-notify-integration --skip-active-record --skip-javascript

WORKDIR mail-notify-integration

# install the gems into the bundle
RUN bundle install

# remove gems that will not work in Rails 5.2.8.1
RUN if [ "${RAILS_VERSION}" = "5.2.8.1" ]; then bundle remove selenium-webdriver chromedriver-helper; fi

# Final stage for app image
FROM base

# Install packages needed for running the tests
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl git && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

WORKDIR /rails/mail-notify-integration

# add Mail Notify to the Gemfile
ARG MAIL_NOTIFY_BRANCH=2.0.0
RUN echo "gem 'mail-notify', git: 'https://github.com/dxw/mail-notify', branch: '${MAIL_NOTIFY_BRANCH}'" >> Gemfile

# install the mail-notify gem, we do this here to keep the last container layer small to help caching
RUN bundle install

# Copy over intergration test files
COPY test/mailers/ test/mailers/
COPY test/system/ test/system/
COPY test/integration test/integration
COPY test/application_system_test_case.rb /test/application_system_test_case.rb
COPY test/app/mailers/ app/mailers/
COPY test/app/views/ app/views/

# Setup the test environment
RUN echo "Rails.application.config.action_mailer.show_previews = true" >> config/environments/test.rb
RUN echo "Rails.application.config.action_mailer.delivery_method = :notify" >>config/environments/test.rb
RUN echo "Rails.application.config.action_mailer.notify_settings = {api_key: ENV['NOTIFY_API_KEY']}" >> config/environments/test.rb

# Run the system tests
CMD ["./bin/rails", "test:system"]
