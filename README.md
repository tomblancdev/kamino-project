<pre>
   ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
  █  T I P O C A   C I T Y         █
  █  growth chamber · ready        █
   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
</pre>

# The genome

This is the template every project is grown from. It is not a project itself —
it is the pattern they are decanted from.

Press **Use this template** above, or:

```sh
gh repo create my-app --template tomblancdev/kamino-project --private --clone
```

Then open the folder in VS Code and choose **Reopen in Container**. That is the
whole setup.

## What happens on first start

The new repo arrives carrying a `.kamino-template` marker. On the first
container start, `kamino-init` — which lives in the
[base image](https://github.com/tomblancdev/kamino), not in this repo — reads
the git remote and your git identity, then writes:

- a `README.md` with the project's own wordmark and badges, replacing this file
- a `LICENSE`, a `.kamino` record, and the terminal wordmark
- a unit designation: a number and a name, like `CT-1141 "Cody"`

Then it deletes its own marker, so it never runs twice. Nothing to run by hand.

## What you actually edit

| File | Purpose | Edit it? |
| --- | --- | --- |
| `mise.toml` | Language runtimes | **Yes — this is the project's identity** |
| `justfile` | Tasks, run inside the container | **Yes — test, lint, fmt** |
| `compose.yaml` | Service, mounts, cache volumes | Only to bump the image tag |
| `lefthook.yml` | Hooks: secrets, lint, commit format | Rarely |
| `cliff.toml` | Changelog rules | Rarely |
| `.devcontainer/devcontainer.json` | Editor integration | Rarely |
| `.devcontainer/post-create.project.sh` | Committed setup (deps, migrations) | Optional |

Every clone starts identical. What it becomes is up to you.

## Pick a language

The image ships no runtime on purpose, so one base serves every stack:

```sh
mise use node@22        # or python@3.13, go@1.24, rust@stable ...
```

That writes `mise.toml`. Commit it, and everyone gets the same versions on the
next container build.

## Conventions you inherit

Commits follow [Conventional Commits](https://www.conventionalcommits.org),
enforced by a hook. Secrets are scanned before every commit and before every
push. Releases derive their version and changelog from those commits:
`just release`, then `git push --follow-tags`.

CI runs the *same* hooks inside the *same* image, so it cannot drift from your
machine.

## Changing the genome

Edit this repository directly — it is the template, not a generated copy.
Changes reach new projects immediately; existing ones are unaffected, because
each pins its own base image tag.

---

<sub>Grown on <a href="https://github.com/tomblancdev/kamino">Kamino</a>.
The lore is decoration; every command and error message says what it means.</sub>
