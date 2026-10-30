ARG RUBY_VERSION=3.4
FROM ruby:${RUBY_VERSION}

# Minimum Bundler: 2.3.27 is the last release that supports Ruby 2.5, and the ruby:2.x
# images ship 1.17. Images that already have a newer Bundler keep it.
ARG BUNDLER_VERSION=2.3.27

WORKDIR /home/angus-sdoc

# The gemspec requires 'angus/sdoc/version' to read the gem version, so version.rb has to be
# in place before bundle install (bancard-commons does not need this).
COPY angus-sdoc.gemspec Gemfile ./
COPY lib/angus/sdoc/version.rb ./lib/angus/sdoc/

RUN gem list -i bundler -v ">= ${BUNDLER_VERSION}" >/dev/null \
      || gem install bundler -v "${BUNDLER_VERSION}" --no-document
RUN bundle install

# Source is copied after the install so dependency changes are the only thing that
# invalidates the bundle layer. See .dockerignore for what stays out (lockfiles, .git).
COPY . .

# Por defecto deja un shell; los tests se ejecutan con:
#   docker run --rm angus-sdoc bundle exec rspec
CMD ["/bin/bash"]
