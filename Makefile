.PHONY: test container-build container-test container-scan

PYTHONPATH := .

PAGERDUTY_SCHEDULE_ID ?= dummy
PAGERDUTY_TOKEN       ?= dummy
SLACK_CHANNEL         ?= dummy
SLACK_TOKEN           ?= dummy

CONTAINER_IMAGE_NAME     ?= ghcr.io/woffenden/good-repo
CONTAINER_IMAGE_TAG      ?= local
CONTAINER_NAME           ?= good-repo

container-build:
	@echo "Building container image $(CONTAINER_IMAGE_NAME):$(CONTAINER_IMAGE_TAG)"
	docker build --platform linux/amd64 --file Dockerfile --tag $(CONTAINER_IMAGE_NAME):$(CONTAINER_IMAGE_TAG) .

container-test: container-build
	@echo "Testing container image $(CONTAINER_IMAGE_NAME):$(CONTAINER_IMAGE_TAG)"
	container-structure-test test --platform linux/amd64 --config test/container-structure-test.yml --image $(CONTAINER_IMAGE_NAME):$(CONTAINER_IMAGE_TAG)

container-scan: container-test
	@echo "Scanning container image $(CONTAINER_IMAGE_NAME):$(CONTAINER_IMAGE_TAG) for vulnerabilities"
	trivy image --platform linux/amd64 --severity HIGH,CRITICAL $(CONTAINER_IMAGE_NAME):$(CONTAINER_IMAGE_TAG)
