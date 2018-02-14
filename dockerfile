FROM elixir:latest
RUN apt-get update && apt-get install --yes postgresql-client
RUN mkdir /app
WORKDIR /app
ADD . /app
ENV MIX_ENV prod
EXPOSE 4000
# Install hex (Elixir package manager)
RUN mix local.hex --force

# Install rebar (Erlang build tool)
RUN mix local.rebar --force

# Install the Phoenix framework itself
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

# Install NodeJS 6.x and the NPM
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Install npm dependencies
Run npm install

# Install all production dependencies
RUN mix deps.get

# Compile all dependencies
RUN mix deps.compile

CMD ["./run.sh"]
