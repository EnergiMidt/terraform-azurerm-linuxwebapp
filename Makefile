default: init


tools:
	@echo "==> installing required tooling..."
	go install github.com/terraform-docs/terraform-docs@v0.16.0

documentation:
	terraform-docs markdown "$(CURDIR)" --output-file README.md

graph:
	@sh -c "'$(CURDIR)/scripts/terraform-graph.sh'"

clean:
	rm --force --recursive --verbose .terraform

init:
	terraform init -upgrade \
	&& terraform init -reconfigure -upgrade

fmt: init
	terraform fmt -recursive . \
	&& terraform fmt -check

fmt-only:
	terraform fmt -recursive . \
	&& terraform fmt -check

validate: fmt
	terraform validate .

validate-only: fmt
	terraform validate .

providers-lock: validate
	terraform providers lock \
		-platform=windows_amd64 \
		-platform=darwin_amd64 \
		-platform=linux_amd64


.PHONY: \
	build \
	documentation \
	fmt \
	fmt-only \
	graph \
	init \
	tools \
	validate \
	validate-only
