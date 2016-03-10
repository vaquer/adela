# See https://github.com/mxabierto/adela/wiki/Docker
FROM mxabierto/ruby:2.3.0-alpine

ENV \
  BUILD_PACKAGES="build-base" \
  RAILS_PACKAGES="libxml2-dev libxslt-dev icu-dev postgresql-dev nodejs"

RUN \
  apk add --update $BUILD_PACKAGES $RAILS_PACKAGES

RUN mkdir /app
WORKDIR /app

# Use libxml2, libxslt a packages from alpine for building nokogiri
RUN bundle config build.nokogiri --use-system-libraries

# Don't install any docs for ruby gems
RUN echo 'gem: --no-rdoc --no-ri' > /etc/gemrc

# cache bundler
COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install

COPY . /app

RUN \
  apk del $BUILD_PACKAGES && \
  rm -rf \
    /usr/share/man \
    /usr/share/doc \
    /tmp/* \
    /var/cache/apk/* \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html

CMD bundle exec puma -C config/puma.rb
