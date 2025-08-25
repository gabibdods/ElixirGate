FROM hexpm/elixir:1.16.3-erlang-26.2.5.4-alpine-3.19.4 AS build

RUN apk add --no-cache build-base git npm

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

COPY . .

ENV MIX_ENV=prod

RUN mix deps.get --only prod

RUN mix deps.compile

RUN mix compile

COPY ./deps/heroicons /app/deps

RUN mix assets.deploy

RUN mix release

FROM alpine:3.19 AS runtime

RUN apk add --no-cache ncurses-libs libstdc++ postgresql16-client ca-certificates

RUN update-ca-certificates

COPY entrypoint.sh /entrypoint.sh

COPY certs/ca.crt /etc/ssl/certs/ca-certificates.crt

RUN chmod +x /entrypoint.sh

WORKDIR /app

COPY --from=build /app/_build/prod/rel/hazegate /app/hazegate

EXPOSE 4000

ENTRYPOINT ["/entrypoint.sh"]
