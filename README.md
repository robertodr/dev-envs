# dev-envs
Collections of Nix shell and direnv files. Used with [`git-along`](https://github.com/nyarly/git-along).

## How to bootstrap the development environment for a new clone

1. Add this repo as an additional remote
```bash
git remote add along git@github.com:robertodr/dev-envs.git
```
2. Create a new stash branch
```bash
git along new-stash
```
3. If using [Niv](https://github.com/nmattia/niv), you have to initialize the folder. `git-along` doesn't seem to play well with folders :shrug:
```bash
niv init
```
4. Merge the remote branch without checkout
```bash
git fetch along +nix-<project_name>:along
```
5. Retrieve the stash branch
```bash
git along retrieve
```
6. Re-run `niv init`

## How to push your changes to this repo
