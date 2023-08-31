FROM ruby:latest

WORKDIR /app

RUN apt-get update && apt-get install -y nodejs postgresql-client

RUN gem install bundler

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]