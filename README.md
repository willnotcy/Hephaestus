# Hephaestus 🛠️ 

A homelab forged with **Proxmox**, **Terraform**, **Talos**, **Flux**, and **Renovate**.

---

## 🚀 Overview

**Hephaestus** is a mono repository for managing my Kubernetes-based homelab. It handles everything from provisioning and configuring virtual machine nodes to automating application deployments and managing backups.

I'm transitioning from a setup based on Proxmox VMs and LXC containers to a more modern, Kubernetes-native environment. The goal is to automate everything—spinning up bare-metal servers, bootstrapping Talos, deploying apps, and keeping everything in sync through CI/CD workflows.

This project is a learning playground, a passion project, hopefully—a way to achieve a wife approved home automation setup.

---

## 🌐 Core stack

| Layer          | Tooling                                                                                                      |
| -------------- | ------------------------------------------------------------------------------------------------------------ |
| Virtualization | [Proxmox VE](https://www.proxmox.com/en/)                                                                    |
| Provisioning   | [Terraform](https://www.terraform.io/) + [Cloud-Init](https://cloudinit.readthedocs.io/)                     |
| Bootstrapping  | [Ansible](https://www.ansible.com/)                                                                          |
| Kubernetes     | [Talos](https://www.talos.dev/)                                                                              |
| GitOps         | [Flux](https://fluxcd.io/)                                                                                   |
| Secrets Management   | [SOPS](https://github.com/mozilla/sops)                          |
| Ingress Controller   | [Traefik](https://doc.traefik.io/traefik/)                          |
|CSI storage   | [democratic-csi](https://github.com/democratic-csi/democratic-csi)                          |
|Backup/Recovery   | [volsync](https://volsync.readthedocs.io/en/stable/)                          |
| Dependency Management   | [Renovate](https://github.com/renovatebot/renovate)                          |
| Observability  | TBD (Prometheus,Loki,Grafana...) |

---

## 🛠️ Goals

- Replace my current Proxmox-based VM/LXC infrastructure with a Kubernetes-first approach
- Automate everything from bare metal provisioning to app deployment
- Maintain a declarative, self-healing, and idempotent system
- Learn and implement best practices around GitOps, CI/CD, Kubernetes security, and infrastructure automation

---

## 📊 Current Status

> \_"Under active development. Expect chaos, pain, and possibly fire."

- ✅ Proxmox environment running
- ✅ Terraform/Ansible bootstrapping complete
- ✅ Talos cluster deployed
- ✅ Flux desired state deployments
- ✅ Automatic backup and restore of Persitent Volumes ([volsync](https://volsync.readthedocs.io/en/stable/))
- ✅ Migrate all LXC applications 
- ⏳ Setup observability/monitoring

---

## 📂 Repository Structure

```
Hephaestus/
├── Talos/             # Talos machine configurations
├── apps/            # Application base definitions and cluster overlays.
├── clusters/          # Cluster resources (Flux, sops, etc.)
├── infrastructure/     # Kubernetes cluster infrastructure code
├── terraform/          # Infrastructure provisioning
└── README.md
```

---

## 🌐 Inspirations

Much inspiration has been taken from the incredible [onedr0p/home-ops](https://github.com/onedr0p/home-ops)/[cluster-template](https://github.com/onedr0p/cluster-template) repository, among others in the self-hosted and GitOps communities. Join the [Home Operations](https://discord.gg/home-operations) Discord community!

---

## 💥 Things I Broke

- **[2025-03-27] The Great Namespace Refactor Disaster**\
  [Commit 3faa0e2](https://github.com/willnotcy/Hephaestus/commit/3faa0e28c636eecd0b08e4a1e607efecfc216ff7) — Moved all `namespace.yaml` files for better structure... and accidentally wiped every application and all their persistent volumes. Learned the hard way how the prune option for Flux kustomizations is applied.

---