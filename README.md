# quarkus-hello-app ACM -> WIP 


Endpoint: http://quarkus-hello-app-quarkus-demo-quarkusjvm.apps.cluster-atlanta-625d.atlanta-625d.sandbox318.opentlc.com/api/hello

## Install ACM Managed and Configure a HUB

Import an existing cluster
![](https://i.imgur.com/IFdi3Ez.png)

Run Genereated command on target machine 
![](https://i.imgur.com/6inP821.png)

View Cluster status
![](https://i.imgur.com/YwLk7w4.png)



## Configure OpenShift client context for cluster admin access 
```
# Login into hub cluster 
oc login -u admin -p XXXX --insecure-skip-tls-verify https://api.YOURCLUSTER1.DOMAIN:6443
# Set the name of the context
oc config rename-context $(oc config current-context) hubcluster
# Login into 1st cluster (A environment)
oc login -u admin -p XXXX --insecure-skip-tls-verify https://api.YOURCLUSTER1.DOMAIN:6443
# Set the name of the context
oc config rename-context $(oc config current-context) cluster1
# Login into 2nd cluster (B environment) ::: OPTIONAL
oc login -u admin -p XXXX --insecure-skip-tls-verify https://api.YOURCLUSTER2.DOMAIN:6443
# Set the name of the context
oc config rename-context $(oc config current-context) cluster2
# Login into 3rd cluster (C environment) ::: OPTIONAL
oc login -u admin -p XXXX --insecure-skip-tls-verify https://api.YOURCLUSTER3.DOMAIN:6443
# Set the name of the context
oc config rename-context $(oc config current-context) cluster3
```

# Test the different cluster contexts
```
# Switch to hub
oc config use-context hubcluster
# Switch to cluster1
oc config use-context cluster1
# List the nodes in cluster1
oc get nodes
# Switch to cluster2
oc config use-context cluster2
# List the nodes in cluster2
oc get nodes
# Switch to cluster3 ::: Optional 
oc config use-context cluster3
# List the nodes in cluster3 ::: Optional 
oc get nodes
# Switch back to cluster1
oc config use-context cluster1
```

## Deploy Quarkus Hello Application on ACM Hub
**From ACM**  
Login to ACM Managed cluster (OCP4 ACM Hub)

**Fork quarkuscoffeeshop-gitops github repo**

**Git clone your forked repo to server**

**Optional: Create a personal access token for forked repo**  
[Creating a personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)


**Login to OpenShift and create project**
```
oc new-project quarkus-hello-demo
```


**Update acm_configs/02_channel.yaml replace with your repo**
```
pathname: 'https://github.com/naveenkendyala/sidebyside-quarkus-hello-demo.git
```

### Configure Services using kustomize
* imageTag is located under the kustomiztion.yaml in each directory 

### Collect the quarkus hello endpoints for config files below 

**Update routes for Quarkus hello Application**
```
cp  clusters/overlays/cluster1/quarkus-hello-app/route.yaml.backup clusters/overlays/cluster1/quarkus-hello-app/route.yaml

cp  clusters/overlays/cluster2/quarkus-hello-app/route.yaml.backup clusters/overlays/cluster2/quarkus-hello-app/route.yaml

cp  clusters/overlays/cluster3/quarkus-hello-app/route.yaml.backup clusters/overlays/cluster3/quarkus-hello-app/route.yaml

# Define the variable of `ROUTE_CLUSTER1`
ROUTE_CLUSTER1=quarkus-hello-app-quarkus-hello-demo.$(oc --context=cluster1 get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')

# Define the variable of `ROUTE_CLUSTER2`
ROUTE_CLUSTER2=quarkus-hello-app-quarkus-hello-demo.$(oc --context=cluster2 get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')

# Define the variable of `ROUTE_CLUSTER3`  ::: OPTIONAL
ROUTE_CLUSTER3=quarkus-hello-app-quarkus-hello-demo.$(oc --context=cluster3 get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')

# Replace the value of changeme with `ROUTE_CLUSTER1` in the file `route.yaml` 
# on linux
sed -i "s/changeme/${ROUTE_CLUSTER1}/" clusters/overlays/cluster1/quarkus-hello-app/route.yaml

# Replace the value of changeme with `ROUTE_CLUSTER2` in the file `route.yaml`
sed -i "s/changeme/${ROUTE_CLUSTER2}/" clusters/overlays/cluster2/quarkus-hello-app/route.yaml

# Replace the value of changeme with `ROUTE_CLUSTER3` in the file `route.yaml`  ::: OPTIONAL
sed -i "s/changeme/${ROUTE_CLUSTER3}/" clusters/overlays/cluster3/quarkus-hello-app/route.yaml
```

## Review cluster configuration
**Cluster1**
```
kustomize build clusters/overlays/cluster1 | less
```

**Cluster2** 
```
kustomize build clusters/overlays/cluster2 | less
```

**Cluster3**
```
kustomize build clusters/overlays/cluster3 | less
```

**Commit and push changes to Github**
```
git add clusters/

git commit -m "Updating Variables for Deployment"

git push 
```

**Use context hubcluster**
```
oc config use-context hubcluster
```

**Create namespace for subscription**
```
oc create -f acm-configs/01_namespace.yaml
```

**Create a Channel**
```
oc create -f acm-configs/02_channel.yaml
```

**Create application**
```
oc create -f acm-configs/03_application_webapp.yaml
```

**Confirm Clusters are properly labeled**
*  `clusterid=cluster1`
*  `clusterid=cluster2`
*  `clusterid=cluster3`
*  `clusterid=...`

**Create placement rules**
```
oc create -f acm-configs/04_placement_cluster1.yaml
oc create -f acm-configs/04_placement_cluster2.yaml
oc create -f acm-configs/04_placement_cluster3.yaml
```

**Create subscription**
```
oc create -f acm-configs/05_subscription_cluster1.yaml
oc create -f acm-configs/05_subscription_cluster2.yaml
oc create -f acm-configs/05_subscription_cluster3.yaml
```

**Verify the deployments have been created on all the clusters.**
```
# cluster 1 
oc config use-context cluster1
oc get pods -n quarkus-hello-demo

# cluster 2
oc config use-context cluster1
oc get pods -n quarkus-hello-demo

# cluster 3
oc config use-context cluster1
oc get pods -n quarkus-hello-demo
```

**Access the cluster URls**
```
# Test against cluster 1
ROUTE_CLUSTER1=quarkus-hello-app-quarkus-hello-demo.$(oc --context=cluster1 get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
curl -s http://$ROUTE_CLUSTER1/api/hello

# Test against cluster 2
ROUTE_CLUSTER2=quarkus-hello-app-quarkus-hello-demo.$(oc --context=cluster2 get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
curl -s http://$ROUTE_CLUSTER2/api/hello

# Test against cluster 3 ::: OPTIONAL
ROUTE_CLUSTER3=quarkus-hello-app-quarkus-hello-demo.$(oc --context=cluster3 get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
curl -s http://$ROUTE_CLUSTER3/api/hello
```


## Quarkus Hello App Policies
[Quarkus Hello App Policies](quarkus-hello-acm-policys.md)