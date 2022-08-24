# Variables
VERBOSE ?= false
RETRY_ATTEMPTS ?= 10
RETRY_SECONDS ?= 30

all: test snyk-test

test:
	@echo "=== newrelic-integration-e2e === [ test ]: running unit tests..."
	@cd newrelic-integration-e2e; go test -race ./... -count=1

snyk-test:
	@docker run --rm -t \
			--name "newrelic-integration-e2e-snyk-test" \
			-v $(CURDIR):/go/src/github.com/newrelic/newrelic-integration-e2e-action \
			-w /go/src/github.com/newrelic/newrelic-integration-e2e-action/newrelic-integration-e2e \
			-e SNYK_TOKEN \
			-e GO111MODULE=auto \
			snyk/snyk:golang snyk test --severity-threshold=high

run:
	@printf "=== newrelic-integration-e2e === [ run / $* ]: running the binary \n"
	@cd newrelic-integration-e2e; go run $(CURDIR)/newrelic-integration-e2e/cmd/main.go \
	 --commit_sha=$(COMMIT_SHA) \
	 --retry_attempts=$(RETRY_ATTEMPTS) \
	 --retry_seconds=$(RETRY_SECONDS) \
	 --account_id=$(ACCOUNT_ID) \
	 --api_key=$(API_KEY) \
	 --license_key=$(LICENSE_KEY) \
	 --spec_path=$(ROOT_DIR)/$(SPEC_PATH) \
	 --verbose_mode=$(VERBOSE) \
	 --agent_enabled=$(AGENT_ENABLED) \
	 --region=$(REGION)
