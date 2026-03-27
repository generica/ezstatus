# syntax=docker/dockerfile:1

FROM golang:1.26-alpine AS build
WORKDIR /src
COPY go.mod ./
COPY cmd ./cmd
RUN CGO_ENABLED=0 go build -o /out/server ./cmd/server

FROM alpine:3.20
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=build /out/server ./
USER nobody
EXPOSE 8080
ENV PORT=8080
ENTRYPOINT ["/app/server"]
