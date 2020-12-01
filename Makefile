PROJECT_NAME = aoc-php

ifeq (, $(shell which docker-compose))
WRAPPER_EXEC =
WRAPPER_EXEC_USER =
else
WRAPPER_EXEC = $(DC_EXEC_ROOT)
WRAPPER_EXEC_USER = $(DC_EXEC_USER)
endif

console: ## Run the project with specified arguments
console:
	@$(DC_RUN_USER) bin/console "$(filter-out $@,$(MAKECMDGOALS))"

###> PHP-MAKEFILE START base ###
PROJECT_DIR ?= $(PWD)

##
## Makefile base
## -------------
##

.DEFAULT_GOAL := help
help: ## Print this help
help:
	@grep -hE '(^[a-zA-Z._-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
	| grep -v "###>" \
	| grep -v "###<" \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

chown-reset: ## reset the owner of all files in this directory and subdirectories
chown-reset:
	@echo "Resetting files rights to the project's user (might prompt super-user)"
	@sudo chown -R $$(id -u):$$(id -g) .

# @see https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line/6273809#6273809
%: # hack to make arguments with targets - use with $(filter-out $@,$(MAKECMDGOALS))
	@:

.PHONY: help chown-reset %
###< PHP-MAKEFILE END base ###

###> PHP-MAKEFILE START docker ###
DOCKER_BIN ?= docker

ifeq ($(shell which $(DOCKER_BIN)),)

root: docker_error

app: docker_error

logs: docker_error

up: docker_error

stop: docker_error

down: docker_error

docker_error:
	$(error "les actions docker ne sont pas disponible dans le container")

.PHONY: docker_error

else

DOCKER_COMPOSE_BIN ?= docker-compose

PROJECT_NAME ?=
DC_RUN_ROOT = $(DOCKER_COMPOSE_BIN) run --rm $(PROJECT_NAME)
DC_RUN_USER = $(DOCKER_COMPOSE_BIN) run --rm --user=$(shell id -u):$(shell id -g) $(PROJECT_NAME)

##
## Docker-specific actions
## -----------------------
##

root: ## docker-compose exec (root)
root:
	@$(DC_RUN_ROOT) "$(filter-out $@,$(MAKECMDGOALS))"

app: ## docker-compose exec on your application container
app:
	@$(DC_RUN_USER) "$(filter-out $@,$(MAKECMDGOALS))"

logs: ## docker-compose logs -f
logs:
	@$(DOCKER_COMPOSE_BIN) logs -f $(filter-out $@,$(MAKECMDGOALS))

up: ## Create the containers (if needed) and launch them
up:
	@$(DOCKER_COMPOSE_BIN) up -d

stop: ## stop the containers
stop:
	@$(DOCKER_COMPOSE_BIN) stop

down: ## Stops containers and removes containers
down:
	@$(DOCKER_COMPOSE_BIN) down

endif

.PHONY: root_ex app ex logs up stop down
###< PHP-MAKEFILE END docker ###

###> PHP-MAKEFILE START composer ###
COMPOSER ?= docker run --rm --interactive --tty \
	--volume $(shell pwd):/app \
	--volume $(HOME)/.composer:/tmp \
	--volume $(SSH_AUTH_SOCK):/ssh-auth.sock \
	--volume /etc/passwd:/etc/passwd:ro \
  	--volume /etc/group:/etc/group:ro \
	--user $(shell id -u):$(shell id -g) \
	--env SSH_AUTH_SOCK=/ssh-auth.sock \
	composer

##
## Composer actions
## ----------------
##

composer: ## composer bin
composer:
	@$(COMPOSER) $(filter-out $@,$(MAKECMDGOALS))

.PHONY: composer
###< PHP-MAKEFILE END composer ###
