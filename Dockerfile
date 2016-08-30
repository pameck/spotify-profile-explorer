FROM ruby:2.3

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    nodejs

ENV APP_HOME /spotify-profile-explorer
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME