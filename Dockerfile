FROM ruby:2.5.1-alpine

RUN apk add --no-cache --update build-base \
    linux-headers \
    git \
    postgresql-dev \
    postgresql-client \
    nodejs \
    tzdata

RUN mkdir -p /gistcatch
WORKDIR /gistcatch
COPY Gemfile* /gistcatch/

ENV RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

# Set bundle paths:
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Install gems:
RUN bundle install --path="$BUNDLE_PATH" --binstubs="$BUNDLE_BIN" \
    --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3 \
    --without development test

COPY . /gistcatch

RUN SECRET_KEY_BASE=`rails secret` rails assets:precompile

EXPOSE 3000

CMD ["rails", "server", "-p", "3000", "-e", "production"]
