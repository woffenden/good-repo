##################################################
# Stage: uv
# From: ghcr.io/astral-sh/uv:python3.13-alpine
##################################################
FROM ghcr.io/astral-sh/uv:python3.13-alpine@sha256:eff16448478e6da617aacc3d766f314bee239b6bc8c6e2af869b9390d8bed784 AS uv

##################################################
# Stage: builder
# From: docker.io/python:3.13-alpine3.22
##################################################
FROM docker.io/python:3.13-alpine3.22@sha256:af1fd7a973d8adc761ee6b9d362b99329b39eb096ea3c53b8838f99bd187011e AS builder

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE="copy"

WORKDIR /app

COPY --from=uv /usr/local/bin/uv /usr/local/bin/uv

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
<<EOF
uv sync --locked --no-install-project --no-editable --no-dev
EOF

##################################################
# Stage: final
# From: docker.io/python:3.13-alpine3.22
##################################################
#checkov:skip=CKV_DOCKER_2: HEALTHCHECK not required

FROM docker.io/python:3.13-alpine3.22@sha256:af1fd7a973d8adc761ee6b9d362b99329b39eb096ea3c53b8838f99bd187011e AS final

LABEL org.opencontainers.image.vendor="Woffenden" \
      org.opencontainers.image.authors="Platform Engineering (platform-engineering@woffenden.io)" \
      org.opencontainers.image.title="good-repo" \
      org.opencontainers.image.description="An opinionated approach of a good repository" \
      org.opencontainers.image.url="https://github.com/woffenden/good-repo"

ENV CONTAINER_USER="nonroot" \
    CONTAINER_UID="65532" \
    CONTAINER_GROUP="nonroot" \
    CONTAINER_GID="65532" \
    APP_HOME="/app" \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:${PATH}"

RUN <<EOF
addgroup -g ${CONTAINER_GID} ${CONTAINER_GROUP}

adduser -D -H -u ${CONTAINER_UID} -G ${CONTAINER_GROUP} ${CONTAINER_USER}

install --directory --mode=0755 --owner="${CONTAINER_USER}" --group="${CONTAINER_GROUP}" "${APP_HOME}"
EOF

WORKDIR ${APP_HOME}
COPY --from=builder --chown=${CONTAINER_UID}:${CONTAINER_GID} /app/.venv /app/.venv
COPY --chown=${CONTAINER_UID}:${CONTAINER_GID} app/ /app

USER ${CONTAINER_UID}

EXPOSE 8080
ENTRYPOINT ["python", "main.py"]
