# dev-envs
Collections of Nix shell and direnv files. Used with [`git-along`](https://github.com/nyarly/git-along).

## How to create a new development environment

1. Create new stash branch
```bash
$ git along new-stash
```
2. Add files to stash branch
```bash
$ git along add shell.nix .envrc
```
3. Add this repo as an additional remote
```bash
$ git remote add along git@github.com:robertodr/dev-envs.git
```
4. Push your stash branch
```bash
$ git push -u along along:nix-<project-name>
```

## How to bootstrap the development environment for a new clone

1. Add this repo as an additional remote
```bash
$ git remote add along git@github.com:robertodr/dev-envs.git
```
2. Create a new stash branch
```bash
$ git along new-stash
```
3. If using [Niv](https://github.com/nmattia/niv), you have to initialize the folder. `git-along` doesn't seem to play well with folders :shrug:
```bash
$ niv init
```
4. Merge the remote branch without checkout
```bash
$ git fetch along +nix-<project_name>:along
```
5. Retrieve the stash branch
```bash
$ git along retrieve
```
6. Re-run `niv init`

## How to push your changes to this repo

1. Check what changed:
```bash
$ git along diff
```
2. Store what changed:
```bash
$ git along store
```
3. You can add new files too:
```bash
$ git along add <new-file>
```
4. Push changes to the relevant project branch of this repository:
```bash
$ git push along
```
