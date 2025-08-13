FROM ruby:3.3

WORKDIR /app

COPY . /app

RUN gem install bundler && bundle install
RUN bundle exec jekyll build

# Use Nginx to serve the static site
FROM nginx:alpine
COPY --from=0 /app/_site /usr/share/nginx/html
EXPOSE 80