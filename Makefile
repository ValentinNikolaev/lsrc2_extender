APP_NAME = Laravel Bootstrap

SHELL ?= /bin/bash
ARGS = $(filter-out $@,$(MAKECMDGOALS))

BUILD_ID ?= $(shell /bin/date "+%Y%m%d-%H%M%S")

.SILENT: ;
.ONESHELL: ;
.NOTPARALLEL: ;
.EXPORT_ALL_VARIABLES: ;
Makefile: ;

# Run make help by default
.DEFAULT_GOAL = help

ifneq ("$(wildcard ./VERSION)","")
VERSION ?= $(shell cat ./VERSION | head -n 1)
else
VERSION ?= 0.0.1
endif

# Public targets

.PHONY: .title
.title:
	$(info $(APP_NAME) v$(VERSION))

.PHONY: build
build:
	docker build \
        --build-arg VERSION=$(VERSION) \
        --build-arg BUILD_ID=$(BUILD_ID) \
        -t $(IMAGE_NAME):$(IMAGE_TAG) \
        --no-cache \
        --force-rm .

.PHONY: up
up:
	docker-compose up -d

.PHONY: bash
bash:
	docker-compose exec app bash

.PHONY: down
down:
	docker-compose down

.PHONY: reset
reset: down up provision

.PHONY: start
start:
	docker-compose start

.PHONY: stop
stop:
	docker-compose stop


.PHONY: help
help: .title
	@echo ''
	@echo 'Usage: make [target] [ENV_VARIABLE=ENV_VALUE ...]'
	@echo ''
	@echo 'Available targets:'
	@echo ''
	@echo '  build         Build or rebuild services'
	@echo '  up            Starts and attaches to containers for a service'
	@echo '  bash          Go to the application container (if any)'
	@echo '  down          Stop, kill and purge project containers.'
	@echo '  start         Start containers.'
	@echo '  stop          Stop containers.'
	@echo ''

%:
	@:

