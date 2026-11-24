# Githeft

Markdown notebooks synced with git, for Android (main target), Linux and the
web. Notes are plain `.md` files with an optional YAML front matter, the
same format GitJournal and Obsidian use, so a notebook stays readable and
editable with any other tool.

## What it does

- **Notebooks** — one git repository each, several side by side. Clone one
  from any git host, start one on the device, or (Linux, web) open an
  existing repository in place.
- **Sync over HTTPS and SSH** — HTTPS with user name and password or access
  token; SSH with a key generated on the device (Ed25519 or RSA) or an
  imported one. SSH host keys are remembered on first use and a changed key
  is refused until you forget the old one.
- **Every change is a commit**; syncing commits leftovers, fetches, merges
  and pushes. Automatic sync after changes, on start and every 10 minutes,
  or by hand.
- **No lost edits** — when two devices changed the same note, the edits are
  merged line by line. If they touch the same lines, your version stays and
  the other becomes a conflict copy (`note.conflict-<time>.md`) next to it. A
  note deleted on one device and edited on the other is kept. The same
  happens when a sync changes a note that is open in the editor.
- **Editor** with Markdown highlighting, toolbar, list continuation, preview,
  tags (front matter and inline `#tags`) and editing of the whole file
  including front matter. Saving only touches the lines it changes, so diffs
  stay small.
- **Browsing** — all notes, folders, tags and search; sort by modified,
  created, title or file name.

## How it is built

```
app/        Flutter app (Android, Linux, web)
proto/      gRPC API between app and core
internal/   Go core: notes, git (go-git), merge, SSH keys, gRPC service
ffi/        libgitheft.so — the core as a library for the app
cmd/githeft command: web server, CLI sync
```

The Go core does all file and git work with go-git, so no git binary is
needed (Android has none). On Android and Linux the app loads
`libgitheft.so` through `dart:ffi`; the core serves gRPC on a Unix socket in
the app's private directory and the app talks to it with the `grpc`
package. The web version is the same Flutter app talking gRPC-Web to
`githeft serve`, which also serves the app's files.

## Building

Everything builds in podman; nothing is installed on the host.

```bash
scripts/build.sh apk                  # build/outputs/githeft-release.apk
scripts/build.sh linux                # build/outputs/githeft-linux/githeft
scripts/build.sh web cli              # app/build/web and build/outputs/githeft
build/outputs/githeft serve -web app/build/web   # http://127.0.0.1:8080
```

`scripts/build.sh` without arguments lists all commands. The Go core alone
builds and tests on the host with a plain Go toolchain:

```bash
go test ./...
```

The generated code in `gen/` and `app/lib/gen/` is checked in. After
changing `proto/`, regenerate it with `scripts/build.sh gen`, which needs
`buf`, `protoc-gen-go` and `protoc-gen-connect-go` on the host (`go install`
them) and takes `protoc-gen-dart` from the toolchain container.

`scripts/emulator.sh` runs the APK in an Android emulator in podman, and
`scripts/emulator.sh remote` starts a throwaway git host next to it
(`scripts/testremote`) to clone from over HTTP and SSH.

## Web server

`githeft serve` keeps its notebooks in `~/.local/share/githeft` (or
`-data`). It listens on 127.0.0.1:8080 by default; to expose it, set a
password (`-password` or `GITHEFT_PASSWORD`, HTTP basic auth) and put it
behind TLS.

## License

MIT
