# Project template

Copy these files into a new project to get the shared development environment.
Nothing here needs renaming — the project name comes from the directory.

```sh
bash scripts/clone.sh ../my-new-project   # or: just clone ../my-new-project
cd ../my-new-project
# then set the runtimes in mise.toml
```

| File | Purpose | Edit it? |
| --- | --- | --- |
| `compose.yaml` | Service, mounts, cache volumes | Set the image tag |
| `.devcontainer/devcontainer.json` | Editor integration | Rarely |
| `mise.toml` | Language runtimes | **Yes — this is the project's identity** |
| `justfile` | Tasks, run inside the container | **Yes — test/lint/fmt** |
| `lefthook.yml` | Hooks: secrets, lint, commit format | Rarely |
| `cliff.toml` | Changelog rules | Rarely |
| `.devcontainer/post-create.project.sh` | Committed setup (deps, migrations) | Optional |

`.github/` — issue forms, PR template, dependabot, CI and release workflows —
is **opt-in**, because an empty project does not need a vulnerability policy or
a release pipeline yet. Answer yes at the prompt, or copy the directory over
later.

`README.md` is generated per clone by `clone.sh`, so this file is only what you
see when browsing the template itself.

## Start it

VS Code: *Reopen in Container*. Otherwise:

```sh
docker compose up -d
docker compose exec dev dev-init   # once per container
docker compose exec dev zsh
```

Starting the container needs no `just` on the host — that's on purpose, so the
host stays free of tooling. The `justfile` holds tasks you run *inside* the
container, where `just` is always present.

## Adding a language

```sh
mise use node@22
```

That writes `mise.toml`, installs into a persistent volume, and puts it on
`PATH`. Commit the file and everyone gets identical versions.

## When the base image isn't enough

If the project needs system packages the base doesn't carry, add a thin
`Containerfile` and point `compose.yaml` at it with `build:` instead of
`image:`:

```dockerfile
FROM ghcr.io/tomblancdev/kamino-dev:trixie-0.1.0
RUN sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends libpq-dev \
 && sudo rm -rf /var/lib/apt/lists/*
```

Prefer this over forking the base image — you keep inheriting its updates.

## Upgrading the base

Change the tag in `compose.yaml` and rebuild. Because the tag is pinned, this
is a deliberate act rather than something that happens to you mid-sprint.
