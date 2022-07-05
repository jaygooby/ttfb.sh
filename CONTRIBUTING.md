# Thanks for helping with ttfb!

Tests live in the [`tests/tests.bats` file](tests/tests.bats) if you're adding a bugfix or making a small change, please ensure all tests pass. 

To run the tests, call `make` from the project root. You'll need to have [bats-core](https://github.com/bats-core/bats-core) installed and in your `$PATH`.

If you only want to run a test or two, uncomment the `# skip` lines on the tests you don't care about, so they read `skip`, and then those tests will be skipped.

If you're thinking about new functionality, check that it can't be achieved by passing `-o` options to curl; for instance, there's no need to raise a PR that makes `ttfb` ignore invalid certificates, you can achieve this by calling ttfb like `ttfb -o "-k" https://example.com` - the `-k` option is added to the `curl` call, and will therefore ignore invalid or expired certificates.

If you do want to add new functionality, please also add a test to [`tests/tests.bats` file](tests/tests.bats).
