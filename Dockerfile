FROM ruby:3.2
RUN mkdir /app && apt-get update \
    && apt-get install ca-certificates curl gnupg -y \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install nodejs -y

COPY . /app
RUN cd /app && gem install bundler && bundle install && chmod 755 /app/boot
ENTRYPOINT ["/app/boot"]
