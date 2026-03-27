# Container images → GitHub Container Registry (ghcr.io/generica/…)
# Needs: docker login ghcr.io (PAT with write:packages)
# Build/push: docker buildx with a builder that can push (default builder is usually fine).

REGISTRY ?= ghcr.io/generica
TAG ?= latest
# Override for multi-arch, e.g. PLATFORM=linux/arm64,linux/amd64
PLATFORM ?= linux/arm64

GOLANG_IMAGE := $(REGISTRY)/ezstatus-golang
PYTHON_IMAGE := $(REGISTRY)/ezstatus-python

.PHONY: help login push-golang push-python push-all

help:
	@echo "ezstatus images → $(REGISTRY)"
	@echo ""
	@echo "  make login        # docker login ghcr.io (once per machine)"
	@echo "  make push-golang  # build & push $(GOLANG_IMAGE):$(TAG)"
	@echo "  make push-python  # build & push $(PYTHON_IMAGE):$(TAG)"
	@echo "  make push-all     # both"
	@echo ""
	@echo "Variables: REGISTRY TAG PLATFORM (default PLATFORM=$(PLATFORM))"

login:
	docker login ghcr.io

push-golang:
	docker buildx build --platform $(PLATFORM) \
		-f services/golang/Dockerfile \
		-t $(GOLANG_IMAGE):$(TAG) \
		--push \
		services/golang

push-python:
	docker buildx build --platform $(PLATFORM) \
		-f services/python/Dockerfile \
		-t $(PYTHON_IMAGE):$(TAG) \
		--push \
		services/python

push-all: push-golang push-python
