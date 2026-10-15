# Tests

Rules for `test/`. Repo-wide rules are in [../AGENTS.md](../AGENTS.md).

The tests check what users see: they run the real CLI and inspect its output and the files it writes.

- Run the CLI as a process: `Process.runSync('dart', [binPath, ...])`, with `binPath` the absolute path to `bin/archify.dart`.
- Any test that writes files runs in its own temp folder (`Directory.systemTemp.createTempSync('archify_test_')`), removed with `addTearDown`. Never run a writing command in the repo itself: it would scaffold into this package.
- Assert on both stdout and the files on disk, e.g. that a generated file exists and contains the expected class.
- `Process.runSync` gives the CLI a closed stdin, so prompts take their default answer. To test another answer, use `Process.start` and write it to stdin. Don't change the default.
- Put new tests in [archify_test.dart](archify_test.dart) next to the tests for the same command, following the existing ones.
