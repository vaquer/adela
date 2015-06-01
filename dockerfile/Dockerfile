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
COPY adela.conf /etc/nginx/sites-enabled/adela.conf

# add environment variables in nginx
COPY env.conf /etc/nginx/main.d/env.conf

# cache bundler
WORKDIR /tmp
COPY Gemfile /tmp/
COPY Gemfile.lock /tmp/
RUN bundle install

# deploy rails app
WORKDIR /home/app/
RUN git clone https://github.com/mxabierto/adela.git
RUN chown app:app -R /home/app/adela
WORKDIR /home/app/adela
RUN bundle install

# clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
