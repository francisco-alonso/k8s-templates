# MongoDB ReplicaSet on Kubernetes using StatefulSets

This repository deploys a **MongoDB ReplicaSet** cluster with 3 members using Kubernetes-native components:
- `StatefulSet` for persistent identity
- `Headless Service` for Pod DNS resolution
- `ConfigMap + initContainer` to automatically initialize the ReplicaSet

---

## Step 1: Start a 3-node Kubernetes cluster with Minikube

We'll use Minikube with Docker driver and multiple nodes:

```bash
minikube start --nodes 3 -p mongo-demo --driver=docker
```

Note: this setup can be done in any other type of cluster either cloud oriented or a custom one.

## Step 2: Create namespace and set context
In order to separate resources within same cluster and environment we should create a proper context for isolation:
```bash
kubectl create namespace mongo-cluster
kubectl config set-context --current --namespace=mongo-cluster
```

## Step 3: Apply resources
1. ConfigMap: contains the startup logic for ReplicaSet configuration.

```bash
kubectl apply -f configmap.yaml
```

2. Headless Service: enables DNS-based Pod discovery (e.g., mongo-0.mongo, mongo-1.mongo, etc.)

```bash
kubectl apply -f service.yaml
```

3. StatefulSet: launches 3 MongoDB Pods with stable network identity and volumes.

```bash
kubectl apply -f statefulset.yaml
```

## Step 4: Validate the setup
Check Pod status
```bash
kubectl get pods
```
Expected output:

```bash
mongo-0   Running
mongo-1   Running
mongo-2   Running
```

If any Pod is stuck in Init, check logs:

```bash
kubectl logs mongo-1 -c init-mongo
```

## Step 5: Check ReplicaSet status
Connect to the primary Pod:

```bash
kubectl exec -it mongo-0 -- mongo
```

Inside the mongo shell:
```bash
rs.status()       // Check member status
rs.conf()         // Check configuration
db.isMaster()     // See if this node is primary
```

## Debugging & Monitoring Commands
DNS resolution test inside cluster
```bash
kubectl run -i --rm --tty busybox --image=busybox --restart=Never -- ping mongo-0.mongo
```

Check PVCs
```bash
kubectl get pvc
```
Full Pod details
```bash
kubectl describe pod mongo-2
```

List container logs
```bash
kubectl logs mongo-1 -c mongodb
kubectl logs mongo-1 -c init-mongo
```