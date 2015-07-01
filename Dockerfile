# See https://github.com/mxabierto/adela/wiki/Docker

FROM phusion/passenger-ruby21:0.9.15

ENV HOME /root
ENV RAILS_ENV production

# use baseimage-docker's init process
CMD ["/sbin/my_init"]

# install dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev

# start nginx/passenger
RUN rm -f /etc/service/nginx/down

# remove the default site
RUN rm /etc/nginx/sites-enabled/default

# add nginx config file
COPY .nginx/adela.conf /etc/nginx/sites-enabled/adela.conf

# add environment variables in nginx
COPY .nginx/env.conf /etc/nginx/main.d/env.conf

# set up working directory
RUN mkdir /home/app/adela
WORKDIR /home/app/adela

# caching bundler
COPY Gemfile /home/app/adela/
COPY Gemfile.lock /home/app/adela/
RUN bundle install

# deploy app
COPY . /home/app/adela
RUN chown app:app -R /home/app/adela
