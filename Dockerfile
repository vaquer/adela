# See https://github.com/mxabierto/adela/wiki/Docker
FROM ruby:2.3.0
MAINTAINER Luis Alfredo Lorenzo <babasbot@gmail.com>

ENV RAILS_ENV production
ENV RACK_ENV production
ENV PORT 80

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libicu-dev \
  libpq-dev \
  nodejs

RUN mkdir /app
WORKDIR /app

# Don't install any docs for ruby gems
RUN echo 'gem: --no-rdoc --no-ri' > /etc/gemrc
# Use libxml2, libxslt a packages from alpine for building nokogiri
RUN bundle config build.nokogiri --use-system-libraries

# cache bundler
COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install

COPY . /app

EXPOSE 80
CMD bundle exec puma -C config/puma.rb
