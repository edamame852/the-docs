---
title: Kubernetes (k8s)
layout: default
parent: Coding Practices
has_children: true
---

# Terminologies
1. `kubectl` = The k8s command line tool
2. container = container runs inside of pods!
    - Containers are lightweight, standalone 
3. service = a k8s resource that provides stable network endpoint (IP & DNS Name) to access a set of pods, enabling communication between pods/ with outside network
4. k8s (API) resources = all k8s objects, entites manged by API resources (e.g. deployments, pods, services...etc)
5. k8s API server = kubectl commands go to here; API Server = centeral management component in the k8s cluster = frontend of the k8s control plane 
6. Ingress vs Egress
    - Similarity: Both are used to describe flow of network traffic from pods to someone else/ some other resources (e.g. pod/ services) 
    - Difference:  
        - ingress: incoming traffic (from external to pod) = who can talk to your pod = into cluster/pod/services
            - example:
                - how users access app from the internet
        - egress: Outgoing traffic (from pod to external) = who your pod can talk to = out of cluster/pod/services
            - example: 
                - pod calls an external API 
                - pod calls an external DB
```bash
    User invoking (kubectl, UI, etc.)
            │
            ▼
    [K8s API Server]
            │
            ▼
    Cluster State (etcd)
            │
            ▼
    Other Control Plane Components
```

# Hierarchy
```
Cluster
│
├── Namespace(s)
│    │
│    └── Pod(s)
│         │
│         ├── Container(s)
│         └── Service(s)
│
└── Node(s) = worker node (physical/virtual), 2 types of nodes: Master (control plane) node & worker node
```

