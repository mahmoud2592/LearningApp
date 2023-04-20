# Base image:
FROM ruby:3.0.3-alpine3.14

# Install dependencies:
RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    tzdata \
    nodejs \
    yarn

# Set working directory:
WORKDIR /myapp

# Copy Gemfile and Gemfile.lock to the container:
COPY Gemfile Gemfile.lock ./

# Install gems:
RUN gem install bundler && \
    bundle config set without 'development test' && \
    bundle install

# Copy the rest of the application code to the container:
COPY . .

# Expose port 3000:
EXPOSE 3000

# Set the command to start the server:
CMD ["rails", "server", "-b", "0.0.0.0"]
