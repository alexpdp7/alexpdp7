# Combining repos with josh-filter

## Introduction

When writing complex software, developers frequently consider incorporating code from other repositories into their repository.
This choice is controversial and this document will not discuss whether incorporating other repositories is the best option.

Developers have different options to perform this task, including:

* Copying the code
* Using Git submodules
* Using Git subtree
* Using repository "orchestration" tools such as Google's repo

A recent option is Josh.
Josh is a daemon that can serve virtual Git repositories that apply transformations to repositories.
With Josh, you can create a virtual Git repository that combines multiple repositories, or a virtual repository that contains a subtree of another repository.

Because Josh is a daemon, using Josh has a greater overhead than other options to combine code from other repositories.
However, Josh provides the josh-filter command that can be used for similar purposes without the extra maintenance of a service.

This document describes a sample scenario and a step-by-step procedure that you can follow along to learn about josh-filter.

## Scenario

A development team maintains the `foo` repository.
The code in the `foo` repository uses external code from the `bar` repository.
The team needs to make changes to code in the `bar` repository, but they have not found a convenient procedure to do so.
Ideally, the team would like to synchronize their changes with the `bar` repository, so that they can benefit from `bar` updates, and contribute back.

## Preparing the example

Create an `example` directory to contain all the files required for this example.

To follow this example, you will need two repositories standing for the `foo` and `bar` repositories.
You can use any repository, but the example assumes that the repos are called `foo` and `bar`, and that the `bar` repository will be copied to the `external/bar` path in the `foo` repository.

The example works with two local mirrored repositories in Git, so you can simulate pushing and pulling from a Git provider such as GitHub.
The example uses `foo.git` and `bar.git` as the URLs of the two repositories.
You can replace the URLs with real repository URLs, or you can create these repositories by mirroring real repositories.
If you use local mirrors, then you can also simulate pushing and pulling without affecting real repositories.

To mirror two repositories locally:

```
git clone --mirror $URL_TO_SOME_REPO foo.git
git clone --mirror $URL_TO_SOME_REPO bar.git
```

(The example also assumes that you are using branches named `main` in both repositories.)

You also need the josh-filter tool.
Follow [the installation instructions](https://josh-project.github.io/josh/reference/cli.html#josh-filter).

## Walkthrough

### Incorporate a repository

Start by cloning the `foo` repository:

```
git clone foo.git
```

This command clones the `foo.git` repository to the `foo` directory.

Change to the `foo` clone.

```
cd foo
```

Create and switch to a `incorporate-bar` branch.

```
git switch -c incorporate-bar
```

Fetch the `main` branch of the `bar` repository.
The `get fetch` command creates a `FETCH_HEAD` reference that contains the `main` branch.
This command is a convenient way to work with multiple repositories.

```
git fetch ../bar.git/ main
```

Use the `josh-filter` command to incorporate the code in the `FETCH_HEAD` reference to the `external/bar` path.
This command takes the `HEAD` reference as an input, and filters another reference using a josh filter.

The following command takes the `FETCH_HEAD` reference that contains the `bar` code.
The `:prefix=external/bar` moves all content of the `FETCH_HEAD` reference to the `external/bar` path.
The result is stored in a new `FILTERED_HEAD` reference.

```
josh-filter ':prefix=external/bar' FETCH_HEAD
```

Merge the `FILTERED_HEAD` reference into your current branch.
Because the `FILTERED_HEAD` reference contains the `bar` code and is unrelated to the current branch in the `foo` repo, you need the `--allow-unrelated` option.

```
git merge --allow-unrelated FILTERED_HEAD
```

After this command, `ls external/bar` and `git log external/bar` show the contents and history of the `bar` repository.
`git log` and tools such as `gitk` will show the combined history of the two repositories.

Push the branch to the `foo.git` remote.

```
git push --set-upstream origin incorporate-bar
```

If you were working with a real repository, then you could create, review, and merge a pull request by following the usual procedures.
If you are using mirrored repositories, then change to the main branch and merge the `incorporate-bar` branch.

```
git switch main
git merge --no-ff incorporate-bar
git push
```

(`git merge --no-ff` is equivalent to the "create a merge commit" button in PRs for GitHub.)

At this point, the `main` branch in the `foo.git` repository contains the code from the `main` branch in the `bar.git` repository in the `external/bar` path.
The code has the full history, and changes can be contributed to and from the `bar.git` repository.

### Incorporating upstream changes from the `bar.git` repository

If new changes are pushed to the `bar.git` repository, then you can pull those changes into the copy in the `foo.git` repository.

#### Simulating changes in the `bar.git` repository

Change to the `example` directory.

Clone the `bar.git` repository.

```
git clone bar.git
```

Change to the `bar` directory and make some changes.

Push the changes to `bar.git`.

```
git push
```

#### Incorporate the changes

Change to the `example/foo` directory.

Create and switch to a `pull-bar` branch.

```
git switch -c pull-bar
```

Fetch the changes again.

```
git fetch ../bar.git/ main
```

If you run the `git log FETCH_HEAD` changes, then you can verify that the changes you made are in `FETCH_HEAD`.

Filter, merge, and push the changes again.

```
josh-filter ':prefix=external/bar' FETCH_HEAD
git merge --allow-unrelated FILTERED_HEAD
git push --set-upstream origin pull-bar
```

After these commands, the `pull-bar` branch contains the new changes from `bar.git`.

If you were working with a real repository, then you could create, review, and merge a pull request by following the usual procedures.
If you are using mirrored repositories, then change to the main branch and merge the `pull-bar` branch.

```
git switch main
git merge --no-ff pull-bar
git push
```

### Upstreaming changes in `foo.git` to `bar.git`

If you make changes to the `external/bar` directory in the `foo.git` repository, you can contribute these changes back to the `bar.git` repository.

#### Simulating changes in the `foo.git` repository

Change to the `example` directory and to the `foo` directory.

Make some changes to the `external/bar` directory.

Push the changes to the `foo.git` repository.

```
git push
```

### Upstreaming the changes

Change to the `example` directory.

Change to the `bar` directory.

```
cd bar
```

Create and switch to a `upstream-from-foo` branch.

```
git switch -c upstream-from-foo
```

Fetch the `main` branch from the `foo.git` repository.

```
git fetch ../foo.git/ main
```

Apply the opposite filter.
The `:/external/bar` filter puts the contents of the `external/bar` directory in the root of the repository.

```
josh-filter ':/external/bar' FETCH_HEAD
```

```
git merge --allow-unrelated FILTERED_HEAD
```

After these commands, the `upstream-from-foo` branch in the `bar.git` repository contains the upstream changes from `foo.git`.

If you were working with a real repository, then you could create, review, and merge a pull request by usual procedures.
If you are using mirrored repositories, then change to the main branch and merge the `upstream-from-foo` branch.

```
git switch main
git merge --no-ff upstream-from-foo
git push
```

## Further possibilities

This walkthrough explains how to incorporate code from a repository into a different repository.
Then, you can synchronize further changes to both repositories.

With similar steps, you can experiment how other Git functionality is affected, such as resolving merge conflicts, or different Git workflows.
