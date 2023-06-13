FROM ruby:3.2.1

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
  build-essential nodejs libpq-dev imagemagick libvips zlib1g-dev apt-utils \
  libmagickwand-dev libmagickcore-dev vim redis-tools 

WORKDIR /umanni
COPY . /umanni
RUN bundle install

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
