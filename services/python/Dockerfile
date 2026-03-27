# syntax=docker/dockerfile:1
# Build for aarch64 hosts (pulls arm64 base), e.g.:
#   docker buildx build --platform linux/arm64 -t ezstatus-python:latest .

ARG TARGETPLATFORM
FROM --platform=$TARGETPLATFORM python:3.12-slim-bookworm AS runtime
WORKDIR /app

RUN useradd --create-home --uid 65532 --shell /usr/sbin/nologin appuser

COPY pyproject.toml ./
COPY ezstatus_py ./ezstatus_py/
RUN pip install --no-cache-dir .

USER appuser
EXPOSE 8081
ENV PORT=8081
CMD ["python", "-m", "ezstatus_py"]
