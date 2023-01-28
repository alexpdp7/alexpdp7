# Personal infra

This is a collection of files I use setting up my personal infrastructure.
This is a work in progress, as I am redoing a bit how I do configuration management.
The main source is in a private repo, but I put here as much material as I can make public.
Inventory, vaults, etc. remain in the private repo.

## Ansible

### Initial setup

Symlink everything in this directory into your root infrastructure directory.

Create an `inventory` file.

Run `./setup_venv` to create a virtual environment.

Create `vault_password` with a vault password.

### Usage

Run `. .venv/bin/activate` to activate the virtual environment.

Run Ansible commands normally.

## Ansible/Puppet integration

I prefer using Ansible for orchestration, and Puppet for configuration management.

`playbooks/roles/apply_puppet` runs Puppet using Ansible.
The `puppet` directory contains Puppet manifests.

The role adds the Ansible inventory to Puppet using Hiera.
