FROM hexpm/elixir:1.13.1-erlang-23.3.4.10-alpine-3.15.0 AS builder

# Need to compile the project in a Linux environment
# because compiling on Windows creates the wrong binary scripts

ARG BUILD_ENV=prod
ARG BUILD_REL=todo

# Install system dependencies
RUN apk add --no-cache git
RUN mix local.hex --force
RUN mix local.rebar --force

# Add sources
ADD . /workspace/
WORKDIR /workspace

ENV MIX_ENV=${BUILD_ENV}

# Fetch depndencies
RUN mix deps.get

# Build release
RUN mix release

FROM alpine:latest AS runner

# Set exposed ports
EXPOSE 5454
ENV PORT 5454

ARG BUILD_ENV=prod
ARG BUILD_REL=todo

# Install system dependencies
RUN apk add --no-cache openssl ncurses-libs libgcc libstdc++

# Install release
COPY --from=builder /workspace/_build/${BUILD_ENV}/rel/${BUILD_REL} /opt/todo

## Configure environment

# We want a FQDN in the nodename
ENV RELEASE_DISTRIBUTION="name"

# This value should be overriden at runtime
ENV RELEASE_IP="127.0.0.1"

# This will be the basename of our node
ENV RELEASE_NAME="${BUILD_REL}"

# This will be the full nodename
ENV RELEASE_NODE="${RELEASE_NAME}@${RELEASE_IP}"

ENTRYPOINT ["/opt/todo/bin/todo"]
CMD ["start"]