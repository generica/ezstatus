# Container images → GitHub Container Registry (ghcr.io/generica/…)
# Needs: docker login ghcr.io (PAT with write:packages)
# Build/push: docker buildx with a builder that can push (default builder is usually fine).

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

REGISTRY ?= ghcr.io/generica
TAG ?= latest
# Override for multi-arch, e.g. PLATFORM=linux/arm64,linux/amd64
PLATFORM ?= linux/arm64

GOLANG_IMAGE := $(REGISTRY)/ezstatus-golang
PYTHON_IMAGE := $(REGISTRY)/ezstatus-python

HELM_NAMESPACE ?= default
# e.g. HELM_ARGS=--create-namespace — extra flags for every helm upgrade
HELM_ARGS ?=

.PHONY: help login push-golang push-python push-all \
	helm-golang helm-python helm-all helm-template-golang helm-template-python

help:
	@echo "ezstatus images → $(REGISTRY)"
	@echo ""
	@echo "Images:"
	@echo "  make login        # docker login ghcr.io (once per machine)"
	@echo "  make push-golang  # build & push $(GOLANG_IMAGE):$(TAG)"
	@echo "  make push-python  # build & push $(PYTHON_IMAGE):$(TAG)"
	@echo "  make push-all     # both"
	@echo ""
	@echo "Helm (sets image repo/tag to match REGISTRY/TAG; needs kubectl context):"
	@echo "  make helm-golang  # upgrade --install ezstatus-golang"
	@echo "  make helm-python  # upgrade --install ezstatus-python"
	@echo "  make helm-all     # both charts"
	@echo "  make helm-template-golang / helm-template-python  # render only"
	@echo ""
	@echo "Variables: REGISTRY TAG PLATFORM HELM_NAMESPACE HELM_ARGS"

login:
	docker login ghcr.io

push-golang:
	docker buildx build --platform $(PLATFORM) \
		-f $(ROOT)/services/golang/Dockerfile \
		-t $(GOLANG_IMAGE):$(TAG) \
		--push \
		$(ROOT)/services/golang

push-python:
	docker buildx build --platform $(PLATFORM) \
		-f $(ROOT)/services/python/Dockerfile \
		-t $(PYTHON_IMAGE):$(TAG) \
		--push \
		$(ROOT)/services/python

push-all: push-golang push-python

helm-golang:
	helm upgrade --install ezstatus-golang $(ROOT)/deploy/helm/golang \
		--namespace $(HELM_NAMESPACE) \
		$(HELM_ARGS) \
		--set image.repository=$(GOLANG_IMAGE) \
		--set image.tag=$(TAG)

helm-python:
	helm upgrade --install ezstatus-python $(ROOT)/deploy/helm/python \
		--namespace $(HELM_NAMESPACE) \
		$(HELM_ARGS) \
		--set image.repository=$(PYTHON_IMAGE) \
		--set image.tag=$(TAG)

helm-all: helm-golang helm-python

helm-template-golang:
	helm template ezstatus-golang $(ROOT)/deploy/helm/golang \
		--namespace $(HELM_NAMESPACE) \
		--set image.repository=$(GOLANG_IMAGE) \
		--set image.tag=$(TAG)

helm-template-python:
	helm template ezstatus-python $(ROOT)/deploy/helm/python \
		--namespace $(HELM_NAMESPACE) \
		--set image.repository=$(PYTHON_IMAGE) \
		--set image.tag=$(TAG)
