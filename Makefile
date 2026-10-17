.PHONY: check lint test spec

check: lint test spec

lint:
	shellcheck 70-wifi-autoswitch install.sh

test:
	bats tests

spec:
	rpmlint wifi-autoswitch.spec
