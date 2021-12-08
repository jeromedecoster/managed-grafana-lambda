.SILENT:

help:
	{ grep --extended-regexp '^[a-zA-Z0-9._-]+:.*#[[:space:]].*$$' $(MAKEFILE_LIST) || true; } \
	| awk 'BEGIN { FS = ":.*#[[:space:]]*" } { printf "\033[1;32m%-18s\033[0m%s\n", $$1, $$2 }'

setup: # terraform setup
	./make.sh setup

validate: # terraform validation
	./make.sh validate

apply: # terraform plan + apply (deploy)
	./make.sh apply

curl-get: # get /
	./make.sh curl-get

curl-rand-success: # post /api/deplay 1 ~ 4 seconds (lambda timeout after 3 seconds)
	./make.sh curl-rand-success

curl-error: # post /api/deplay 10 ~ 29 seconds
	./make.sh curl-error

destroy: # destroy all resources
	./make.sh destroy
