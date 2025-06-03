# Homelab

This is the gitops repository for my self-hosted services and homelab.

## Build Image(s)

```sh
task packer
```

## Deploy Incus Instances

```sh
task tofu-init
task tofu-apply
```

## View Inventory

```sh
task inventory
```

## Apply Configuration (Ansible)

```sh
task ansible
```
