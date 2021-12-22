FROM ruby:2.7.1-alpine3.12

# hadolint ignore=DL3018
RUN apk update && \
    apk add --no-cache \
    build-base \
    postgresql-dev \
    bash \
    curl \
    tzdata \
    git \
    vim \
    shared-mime-info

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler:2.1.4
RUN bundle config set without 'development test'
RUN bundle install --jobs 3

COPY . /app

EXPOSE 3000

CMD ["bash", "-c", "bundle", "exec", "puma", "-C", "config/puma.rb"]
