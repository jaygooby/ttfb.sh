default: test

.PHONY: check-bats-exists
check-bats-exists:
	@which bats > /dev/null || (echo "Missing dependency. You need to ensure that 'bats' is installed and in your \$$PATH. See https://github.com/bats-core/bats-core" && exit 1)

.PHONY: test
test: check-bats-exists
	bats tests/
