oc apply -f deployment.yaml
oc expose deployment.apps/quarkus-hello-deploy
oc expose service/quarkus-hello-deploy
oc autoscale deploy/quarkus-hello-deploy --min 1 --max 10 --cpu-percent=50