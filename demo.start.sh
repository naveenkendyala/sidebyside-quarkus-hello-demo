#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
# Scale it back to 0 instance
read -p $'\e[32m[STEP-00] : Create NameSpace acm-demo and change to namespace \e[0m'
oc apply -f acm-configs/01_namespace.yaml
oc project acm-demo

read -p $'\e[32m[STEP-01] : Create Application [acm-demo-app] \e[0m: '
oc apply -f acm-configs/02_application.yaml

read -p $'\e[32m[STEP-02] : Create a Channel for Application [acm-demo-app] \e[0m: '
oc apply -f acm-configs/03_channel.yaml

read -p $'\e[32m[STEP-03] : [CLUSTER1] Create Subscription and Placement Rule \e[0m: '
oc apply -f acm-configs/04_subscription_cluster1.yaml
oc apply -f acm-configs/05_placement_cluster1.yaml

read -p $'\e[32m[STEP-03] : [CLUSTER2] Create Subscription and Placement Rule \e[0m: '
oc apply -f acm-configs/06_subscription_cluster2.yaml
oc apply -f acm-configs/07_placement_cluster2.yaml
