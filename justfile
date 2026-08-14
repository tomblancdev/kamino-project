# Project tasks. Run these *inside* the container, where `just` always exists.
#
# Starting the container is a host-side job, and deliberately needs no `just`
# on the host — three plain commands do it:
#
#   docker compose up -d              start
#   docker compose exec dev zsh       get a shell
#   docker compose down               stop
#
# VS Code users get all of that from "Reopen in Container".

_default:
    @just --list

# Re-run first-run setup (runtimes, hooks). Normally automatic.
init:
    dev-init

# Install/refresh the runtimes declared in mise.toml.
runtimes:
    mise install

# What's out of date, runtimes and all.
outdated:
    mise outdated

# Scan the working tree for committed secrets.
scan:
    gitleaks git --redact --no-banner

# Run the git hooks by hand, without committing.
hooks:
    lefthook run pre-commit

# --- releases ---------------------------------------------------------------
# Versions come from Conventional Commits, so the changelog and the version
# number are both derived from history rather than maintained by hand.

# What the next tag would be, given the commits since the last one.
next-version:
    @git-cliff --bumped-version

# Regenerate CHANGELOG.md from the full history.
changelog:
    git-cliff -o CHANGELOG.md
    @echo "CHANGELOG.md regenerated — review before committing"

# Preview the notes for the unreleased commits only.
changelog-preview:
    @git-cliff --unreleased --strip all

# Cut a release: bump the version, write the changelog, commit, tag.
# Push afterwards with `git push --follow-tags` to trigger the release workflow.
release:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "$(git status --porcelain)" ]; then
        echo "working tree is dirty — commit or stash first" >&2
        exit 1
    fi
    version="$(git-cliff --bumped-version)"
    if [ -z "${version}" ]; then
        echo "no releasable commits since the last tag" >&2
        exit 1
    fi
    echo "releasing ${version}"
    git-cliff --bump -o CHANGELOG.md
    git add CHANGELOG.md
    git commit -m "chore(release): ${version}"
    git tag -a "${version}" -m "${version}"
    echo
    echo "tagged ${version}. Publish it with:"
    echo "  git push --follow-tags"

# --- add your project's tasks below -----------------------------------------
# These are the ones that earn a task runner. Fill them in for the stack you
# picked in mise.toml, for example:
#
# test:
#     pytest -q
#
# lint:
#     ruff check .
#
# fmt:
#     ruff format .
#
# dev:
#     watchexec -e py -r -- python -m myapp
