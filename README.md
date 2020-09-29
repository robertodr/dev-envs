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
3. Merge the remote branch without checkout
```bash
git fetch along +nix-<project_name>:along
```
