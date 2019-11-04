##
## Magic Makefile
##

DOCKER_REPO ?= $(subst .,/,$(notdir $(PWD)))
DOCKER_TAG ?= latest

BUILD_PATH ?= /
DOCKERFILE_PATH ?= Dockerfile

, = ,
ALL_TAGS = $(subst $(,), ,$(DOCKER_TAG))
TAG_LIST = $(foreach tag,$(ALL_TAGS),-t "$(DOCKER_REPO):$(tag)")
ARG_LIST = $(foreach arg,$(BUILD_ARGS),--build-arg "$(arg)")

build:
	docker image build $(TAG_LIST) $(ARG_LIST) -f ".$(BUILD_PATH)/$(DOCKERFILE_PATH)" ".$(BUILD_PATH)"

push:
	$(foreach tag,$(ALL_TAGS),docker image push "$(DOCKER_REPO):$(tag)" &&) true


image: CENTOS_VERSION ?= latest
image: DOCKER_TAG := centos$(CENTOS_VERSION),$(CENTOS_VERSION)
image: BUILD_ARGS += CENTOS_VERSION=$(CENTOS_VERSION)
image: build push


all:
	$(MAKE) image CENTOS_VERSION=latest DOCKER_TAG=latest
	$(MAKE) image CENTOS_VERSION=8
	$(MAKE) image CENTOS_VERSION=7
	$(MAKE) image CENTOS_VERSION=7.6.1810
	$(MAKE) image CENTOS_VERSION=7.5.1804
	$(MAKE) image CENTOS_VERSION=7.4.1708
	$(MAKE) image CENTOS_VERSION=7.3.1611
	$(MAKE) image CENTOS_VERSION=7.2.1511
	$(MAKE) image CENTOS_VERSION=7.1.1503
	$(MAKE) image CENTOS_VERSION=7.0.1406
	$(MAKE) image CENTOS_VERSION=6
