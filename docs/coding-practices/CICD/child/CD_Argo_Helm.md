---
title: ArgoCD & HelmCharts
layout: default
parent: CICD
grand_parent: Coding Practices
has_children: true
---

# Background

1. Helm is one of many package managers for k8s.
2. K8S objects = K8S manifests yaml files
3. Under the hood, Argo CD can be deployed using helm charts
4. Helm charts are packaged up k8s manifests files in the for of helm templates, .tpl files that are fundamentally written in the Go Language.

## Argo CD
- Argo CD can use Helm, Kustomize, jsonnet under the hood to help with CD
- Argo CD can allow applications to self-heal, self-prune, auto-sync with their connected Github Repos.
- Argo CD application can auto run, build services, service accounts, deployment and wrap it up with ingress control.

### Common issues:
- 1. Ingress is stuck at "Progressing" state
     - Ans: Likely due to missing resources in the ClusterConfig role. Need admin users with Cluster level access to fix and add the following back to the ClusterConfig...
          - 

## Helm
Pros of Helm: Saves a lot of time to rewrite yaml manifests files for the same deployment across envs and regions
Cons of Helm: Harder to debug due to templates logics all wrapped up in go and common helper functions

