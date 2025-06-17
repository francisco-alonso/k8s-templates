## Prerequisites

Parse uses a MongoDB cluster for its storage. Please check `mongo-cluster` described at the root of this repository in order to know how to set up a
replicated MongoDB cluster using Kubernetes StatefulSets. This section assumes:
- You have a three-replica Mongo cluster running in Kubernetes with the names mongo-0.mongo, mongo-1.mongo, and mongo-2.mongo.
- You have a Docker login; if you don't have one, you can get one for free at https://docker.com.
- You have a Kubernetes cluster deployed and the kubectl tool properly configured.

## Step 1: Create Mongo Cluster
Refer to `mongo-cluster` [repo](..\mongo-cluster).

Note: make sure mongo cluster and parse resources are created under the same namespace.

## Step 2: Apply resources
1. Deployment: contains the parse service with a cmd config to target the Mongo cluster.

```bash
kubectl apply -f parse.yaml
```

2. Service: enables DNS-based Pod discovery

```bash
kubectl apply -f service.yaml
```
## Step 3: Connect to the pod

Run to get pod name
```bash
kubectl get pods -l run=parse-server
```

You will get something like 

```bash
NAME                            READY   STATUS    RESTARTS   AGE
parse-server-xxxxxxxxxx-xxxxx   1/1     Running   0          5m
```

Connect to pod:
```bash
kubectl exec -it <pod-name> -- /bin/bash
```

Test parse server internally

```bash
curl -X GET \
  -H "X-Parse-Application-Id: test-id" \
  http://localhost:1337/parse/health
```

📦 Tip: Install curl if missing
If the pod lacks curl, you can use a debug pod instead:

```bash
kubectl run curl-pod --image=curlimages/curl -it --rm -- sh
```
Then test with:

```bash
curl http://parse-server.default.svc.cluster.local:1337/parse/health \
  -H "X-Parse-Application-Id: test-id"
```