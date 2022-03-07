COMPOSE_RUN_TERRAFORM = docker-compose run --rm tf
COMPOSE_RUN_BASH = docker-compose run --rm --entrypoint bash tf
COMPOSE_RUN_AWS = docker-compose run --rm --entrypoint aws tf

GETACCOUNTID = $(eval AWS_ACCOUNT_ID=$(shell aws sts get-caller-identity --output text --query 'Account'))
GETREGION = $(eval AWS_REGION=$(shell aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'))
GETURI = $(eval IMAGEFULLNAME=$(shell echo $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/ccr-weather-app:1))
#IMAGEFULLNAME = $(shell echo $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/ccr-weather-app:1)


.PHONY: run_plan
run_plan: set_vars init plan

.PHONY: run_apply
run_apply: init apply

.PHONY: run_destroy_plan
run_destroy_plan: init destroy_plan

.PHONY: run_destroy_apply
run_destroy_apply: init destroy_apply

.PHONY: docker_workflow
docker_workflow: login build push

.PHONY: set_vars
set_vars: 
	$(GETREGION) \
	$(GETACCOUNTID) \
	$(GETURI)

.PHONY: version
version:
	$(COMPOSE_RUN_TERRAFORM) --version
	
.PHONY: init
init:
	set_vars
	$(COMPOSE_RUN_TERRAFORM) init -input=false
	-$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt	

.PHONY: plan
plan:
	$() \
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false -var="image_uri=$(IMAGEFULLNAME)"

.PHONY: apply
apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"

.PHONY: destroy_plan
destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy

.PHONY: destroy_apply
destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve

.PHONY: build
build:
		@echo "Building image with tag ${IMAGEFULLNAME}"
	    @docker build -t ${IMAGEFULLNAME} -f ./weather-app.dockerfile .

.PHONY: push
push:
		@echo "Pushing image with tag ${IMAGEFULLNAME} to DockerHub"
	    @docker image push ${IMAGEFULLNAME}

.PHONY: login
login:
		@echo "Logging into ECR with provided credentials"
		@aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS \
		--password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com