# Redis Cluster

1. Config Maps: scripts to define redis master/slave config and redis sentinel.
```bash
kubectl create configmap redis-config --from-file=slave.conf=./slave.conf --from-file=master.conf=./master.conf --from-file=sentinel.conf=./sentinel.conf --from-file=init.sh=./init.sh --from-file=sentinel.sh=./sentinel.sh --dry-run=client -o yaml > redis-configmap.yaml
```

2. StatefulSet and Service

- Apply statefulset with 3 sentinel and redis instances running.
- Expose pods through a service. Reachable through DNS or internal IP.
```bash
kubectl apply -f redis.yaml
kubectl apply -f redis-service
```
