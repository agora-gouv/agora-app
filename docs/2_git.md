# Utils

# Git

## Branch naming
`<type>`/`<ticket-number>`-`<name-of-branch>`.

`<type>` could be :
  - feat
  - refactor
  - tech
  - feedback

Example: *feat/1-details*

## Pull requests

- Create new branch from `develop` and push it to GitHub.
- Create pull requests


## Branch merging

```shell
## Ensure your develop branch is up to date
git checkout develop
git pull --rebase

## Go to your current branch and rebase it onto develop
git checkout feat/1-details
git rebase develop
git push --force-with-lease
```

## Commit naming

We use this convention:

```text
<type>-<ticket-number>: <name of commit>
```

Examples :

```text
feat-1: add files
refactor: fix somethings
```
