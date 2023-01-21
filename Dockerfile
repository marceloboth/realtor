# Make sure it matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.0
FROM ruby:$RUBY_VERSION

SHELL ["/bin/bash", "-c"]

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 19.4.0
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

RUN mkdir -p $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    freetds-dev \
    wget \
    curl \
    software-properties-common \
    apt-transport-https \
    libssh-dev \
    chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && gem install bundler \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install --global yarn

ENTRYPOINT ["/bin/bash"]
