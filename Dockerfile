FROM ruby:3.2.1

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

RUN apt update -y && apt install -qq -y --no-install-recommends \
  build-essential nodejs libpq-dev imagemagick libvips zlib1g-dev apt-utils \
  libmagickwand-dev libmagickcore-dev vim redis-tools 

RUN npm install -g yarn
RUN gem install bundler -v 2.4.13

WORKDIR /umanni

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install 

RUN bundle exec rails assets:precompile

COPY package.json yarn.lock ./

RUN yarn install --check-files

ENV POSTGRES_HOST=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
ENV REDIS_URL=redis://redis:6379/0

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
