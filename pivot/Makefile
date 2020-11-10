# import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= .env
include $(cnf)


# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

DOCKER_REPO=$(AWS_ACCOUNT).dkr.ecr.$(AWS_CLI_REGION).amazonaws.com


# DOCKER TASKS
# Build
data-prep: ## Transfer data for Docker build
	rm -rf ./data/*
	yes | cp -rf ../app_data/pickled_data_sample_${SAMPLE_RECORDS}k.pkl ./data/

build: data-prep ## Build the service
	docker-compose build

build-nc: data-prep ## Build the service without caching
	docker-compose build --no-cache

# Run
run: ## Run container on port configured in `config.env`
	docker stop $(IMG_NAME) || true
	# TODO: merge this with docker-compose for env var handling
	docker run -i -t --rm --env-file=./.env -p=$(PORT):$(PORT) -e STREAMLIT_DATA="pickled_data_sample_${SAMPLE_RECORDS}k.pkl" --name="$(IMG_NAME)" $(IMG_NAME)

up: build run ## Run container on port configured in `config.env` (Alias to run)

stop: ## Stop and remove a running container
	docker stop $(IMG_NAME); docker rm $(IMG_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to ECR


# Publish
check-repo:
	aws ecr describe-repositories --repository-names $(IMG_NAME) || aws ecr create-repository --repository-name $(IMG_NAME)

publish: repo-login publish-latest # publish-version ## Publish the `latest` tagged containers to ECR

publish-latest: check-repo tag-latest ## Publish the `latest` taged container to ECR
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(IMG_NAME):latest

#publish-version: tag-version ## Publish the `{version}` taged container to ECR
#	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
#	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest # tag-version ## Generate container tags for `latest` tags

tag-latest: ## Generate container `latest` tag
	@echo 'create tag latest'
	docker tag $(IMG_NAME) $(DOCKER_REPO)/$(IMG_NAME):latest

#tag-version: ## Generate container `latest` tag
#	@echo 'create tag $(VERSION)'
#	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)


# HELPERS

# generate script to login to aws docker repo
CMD_REPOLOGIN := "eval $$\( aws ecr"
ifdef AWS_CLI_PROFILE
CMD_REPOLOGIN += " --profile $(AWS_CLI_PROFILE)"
endif
ifdef AWS_CLI_REGION
CMD_REPOLOGIN += " --region $(AWS_CLI_REGION)"
endif
CMD_REPOLOGIN += " get-login --no-include-email \)"

# login to AWS-ECR
repo-login: ## Auto login to AWS-ECR unsing aws-cli
	@eval $(CMD_REPOLOGIN)

#version: ## Output the current version
#	@echo $(VERSION)
