FROM ruby:latest

# Set environment variables for Rails
ENV RAILS_ENV production
ENV RACK_ENV production

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock /app/

# Install dependencies
RUN gem install bundler:2.2.29 && bundle install --jobs 20 --retry 5

# Copy the application code into the container
COPY . /app

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]