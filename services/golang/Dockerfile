# syntax=docker/dockerfile:1
# Cross-compile for aarch64 hosts, e.g.:
#   docker buildx build --platform linux/arm64 -t ezstatus-golang:latest .

FROM --platform=$BUILDPLATFORM golang:1.26-alpine AS build
ARG TARGETOS
ARG TARGETARCH
WORKDIR /src
COPY go.mod ./
COPY cmd ./cmd
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/server ./cmd/server

ARG TARGETPLATFORM
FROM --platform=$TARGETPLATFORM alpine:3.20
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=build /out/server ./
USER nobody
EXPOSE 8080
ENV PORT=8080
ENTRYPOINT ["/app/server"]
