# Base settings
GOOS := linux
GOARCH := arm64
BUILD_DIR := .aws-sam/build
ENV ?= sandbox

# Validate ENV early
ifeq ($(filter $(ENV),sandbox prod),)
$(error ❌ Invalid ENV value "$(ENV)". Allowed: sandbox, prod)
endif

# Profiles per environment
ENV_PROFILE := bradley_marques_sandbox_developer
ifeq ($(ENV),prod)
	ENV_PROFILE := bradley_marques_production
endif

# Lambda function names = directory names in cmd/lambda/
LAMBDA_FUNCTIONS := GetP3RPersonas

.PHONY: all check-sso validate-tools build deploy clean

all: build

validate-tools:
	@command -v aws >/dev/null 2>&1 || (echo "❌ 'aws' CLI not found in PATH" && exit 1)
	@command -v sam >/dev/null 2>&1 || (echo "❌ 'sam' CLI not found in PATH" && exit 1)
	@command -v go >/dev/null 2>&1 || (echo "❌ 'go' not found in PATH" && exit 1)

check-sso: validate-tools
	@echo "🔍 Checking AWS SSO session for profile '$(ENV_PROFILE)'..."
	@aws sts get-caller-identity --profile "$(ENV_PROFILE)" >/dev/null 2>&1 || \
		( \
			echo "\n🔒 SSO session expired or missing. Run:"; \
			echo "   aws sso login --profile $(ENV_PROFILE)\n"; \
			exit 1 \
		)
	@echo "✅ AWS SSO session is active."

# Build each Lambda binary into .aws-sam/build/<FunctionName>/bootstrap
build: validate-tools
	@echo "🔨 Building Go Lambda binaries..."
	@for func in $(LAMBDA_FUNCTIONS); do \
		OUT_DIR="$(BUILD_DIR)/$$func"; \
		SRC="cmd/lambda/$$func/main.go"; \
		if [ ! -f "$$SRC" ]; then echo "❌ Missing entrypoint: $$SRC" && exit 1; fi; \
		mkdir -p "$$OUT_DIR"; \
		echo "📦 Compiling $$SRC → $$OUT_DIR/bootstrap..."; \
		GOOS=$(GOOS) GOARCH=$(GOARCH) go build -ldflags="-s -w" -o "$$OUT_DIR/bootstrap" "$$SRC"; \
	done
	@echo "✅ All functions built."

deploy: check-sso build
	@echo "🚢 Deploying to environment '$(ENV)'..."
	sam deploy --config-env "$(ENV)" \
    --no-confirm-changeset \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM
	@echo "✅ Deployment complete."
	@$(MAKE) clean


clean:
	@echo "🧹 Cleaning up build artifacts..."
	@rm -rf "$(BUILD_DIR)" .aws-sam
	@echo "✅ Clean complete."
