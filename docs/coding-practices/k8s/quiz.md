---
title: Quiz (?)
layout: default
parent: Kubernetes (k8s)
grand_parent: Coding Practices
has_children: true
---


# QUIZ Questions

32. 


33. Which of the following are valid reasons for using k8s?
    - Options:
        - k8s automates high avaliability and DR (Disater Recovery)
        - :heavy_check_mark: k8s automates the scheduling, starting, stopping, and updating of containers
            - Explanation: k8s auto start, stop, scale, update containerized apps and makes deployment easy :D
        - :heavy_check_mark: All apps deployed to k8s can be scaled by deafult, based on memory and cpu consumption
            - Explanation: k8s has horizontal scaling (e.g. on mem and cpu  usages) handling muliple workloads without manual involvement
        - :heavy_check_mark: K8s automates container patching + ensures the latest common vulns exposures (CVE) are fixed
            - Explanation: k8s has features like auto rolling updates = to patch security loopholes and update containers. k8s has eco-system to include tools and vlun scanning and monitoring
        - Containers deployed to k8s are automatically secured.
    > Gist: 

34. Which of the following CANNOT be performed with network policies in k8s?
    - 5 Options (only 1 is the odd man out):
        - Only accepting connections from frontend pods
        - :heavy_check_mark: Forcing internal cluster traffic to go through a common gateway
            - This cannot be done through NetworkPolicies since NetworkPolicy enforce L3 and L4 layer rules (accept/deny) and doesn't change routing/ force traffic through a particular hop
        - Specify the allowed protocols (TCP, UDP, SCTP) and port numbers
        - Deny all ingress and all egress traffic by default
        - Only accept connections from pods within the same namespace
    > Gist: k8s cannot force traffic routing through a common gateway using NetworkPolicies. NetworkPolicies only enforce L3 and L4 layer rules (accept/deny) and doesn't change routing/ force traffic through a particular hop.

35. Which commands will list all avaliable API resources in k8s?
    - Options:
        - `kubectl api-objects` : No such command
        - `kubectl get api-resources`: No such command
        - :heavy_check_mark: `kubectl api-resources`: listing all resource types in the k8s api server
        - `kubectl get all`: Listing all core types in the ns
        - `kubectl describe api-resources` : No such command

36. How does a k8s container discover a service?
    - Facts:
        - k8s container relys on 2 things to perform service discovery: DNS entries + injecting ENV vars into pod during pod creation
        - k8s container manager doesn't exist
        - Dockerfile contains instructions to build (container) image, it does not help configure anything k8s related 
    - Choices:
        - :heavy_check_mark: For every service.yaml, an env variable inside the container gets created containing the IP address of the service
            - Correct: Since k8s **auto-injects** env var into each pod for every service in the same namespaces. These envs include service cluster IP & port number. Hence containers can discover services via env vars!
        - By using k8s container manager
        - Which services are avaliable for the container are all configured in the deployment
        - It's specified in the container's Dockerfile which services are avaliable
        - :heavy_check_mark: Every service has a DNS entry which can be used to connect to the service
            - Correct: Since k8s creates a DNS entry per service, hence the dns names can help connect to services within the cluster
