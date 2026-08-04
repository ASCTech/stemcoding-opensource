ARG RUBY_VERSION=3.4.10
FROM ruby:${RUBY_VERSION}-slim-bookworm

ARG NODE_MAJOR=20
ARG BUNDLER_VERSION=2.7.0

ENV APP_ROOT=/app \
    LANG=C.UTF-8 \
    GEM_HOME=/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
    BUNDLE_BIN=$BUNDLE_PATH/bin

ENV PATH=/app/bin:$BUNDLE_BIN:$PATH

# System dependencies:
#   build-essential, libpq-dev  -> compile native gems (pg, etc.)
#   libvips                     -> image_processing / carrierwave variants
#   postgresql-client           -> psql + pg_isready in scripts
#   git, curl, gnupg            -> fetch Node/Yarn and any git-sourced gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      gnupg \
      libpq-dev \
      libvips \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Node.js (NodeSource) + Yarn (classic)
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install --global yarn && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --user-group deploy && \
    mkdir -p ${APP_ROOT} ${GEM_HOME} && \
    chown -R deploy:deploy ${APP_ROOT} ${GEM_HOME}

USER deploy
WORKDIR ${APP_ROOT}

RUN gem install bundler:${BUNDLER_VERSION}

# Install Ruby gems first so the layer caches independently of app code.
COPY --chown=deploy:deploy Gemfile Gemfile.lock ${APP_ROOT}/
RUN bundle install

# Install JS packages next, same caching rationale.
COPY --chown=deploy:deploy package.json yarn.lock ${APP_ROOT}/
RUN yarn install --frozen-lockfile

COPY --chown=deploy:deploy . ${APP_ROOT}/

ENTRYPOINT ["/app/docker-entrypoint.sh"]
