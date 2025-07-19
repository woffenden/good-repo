##################################################
# Stage: uv
# From: ghcr.io/astral-sh/uv:python3.13-alpine
##################################################
FROM ghcr.io/astral-sh/uv:python3.13-alpine@sha256:66fc613d6880444f8593aa0a158716448e7ed6f0dc7965383d10f6b8e51d5769 AS uv

##################################################
# Stage: builder
# From: docker.io/python:3.13-alpine3.21
##################################################
FROM docker.io/python:3.13-alpine3.21@sha256:c9a09c45a4bcc618c7f7128585b8dd0d41d0c31a8a107db4c8255ffe0b69375d AS builder

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
# From: docker.io/python:3.13-alpine3.21
##################################################
#checkov:skip=CKV_DOCKER_2: HEALTHCHECK not required

FROM docker.io/python:3.13-alpine3.21@sha256:c9a09c45a4bcc618c7f7128585b8dd0d41d0c31a8a107db4c8255ffe0b69375d AS final

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
adduser -D -u ${CONTAINER_UID} -g ${CONTAINER_GID} ${CONTAINER_USER}

install --directory --mode=0755 --owner="${CONTAINER_USER}" --group="${CONTAINER_GROUP}" "${APP_HOME}"
EOF

WORKDIR ${APP_HOME}
COPY --from=builder --chown=${CONTAINER_UID}:${CONTAINER_GID} /app/.venv /app/.venv
COPY --chown=${CONTAINER_UID}:${CONTAINER_GID} app/ /app

USER ${CONTAINER_UID}

EXPOSE 8080
ENTRYPOINT ["python", "main.py"]
