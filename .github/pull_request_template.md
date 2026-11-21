<!--
  Title: Conventional Commits, e.g. "fix(rust): color attributes like GitLab" or
  "feat(neogit): add highlight groups". It becomes the commit message and the changelog entry.
-->

## What does this change?

<!-- One topic per PR: one language, one plugin, or one bug. -->

## Related issue

<!-- e.g. Fixes #123 -->

## Screenshots

<!-- For color changes: before / after, and a GitLab screenshot of the same code if you can. -->

| Before | After | GitLab |
|---|---|---|
| | | |

## Checklist

- [ ] The title follows [Conventional Commits](https://github.com/MNnazrul/tanuki-night.nvim/blob/main/CONTRIBUTING.md#pull-request-titles-and-commit-messages)
- [ ] I read [CONTRIBUTING.md](https://github.com/MNnazrul/tanuki-night.nvim/blob/main/CONTRIBUTING.md)
- [ ] Checked in both styles (`tanuki-night` and `tanuki-day`)
- [ ] Ran `make gen` and committed the generated files
- [ ] `make test`, `make test-vim` and `make lint` pass (and `make test-queries` if I changed `queries/`)
- [ ] Updated `README.md` / `doc/tanuki-night.txt` if behavior or options changed
