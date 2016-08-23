#!/bin/bash

source ~/overcloudrc

echo START BUILD NETWORKS

neutron net-create app
neutron net-create db
neutron net-create web
neutron net-create dev
neutron net-create utility
neutron subnet-create --name app --gateway 172.16.2.1 app 172.16.2.0/23
neutron subnet-create --name db --gateway 172.16.4.1 db 172.16.4.0/23
neutron subnet-create --name web --gateway 172.16.6.1 web 172.16.6.0/23
neutron subnet-create --name dev --gateway 172.16.8.1 dev 172.16.8.0/23
neutron subnet-create --name utility --gateway 172.16.10.1 utility 172.16.10.0/23
neutron net-create nova --router:external --provider:network_type flat --provider:physical_network datacentre
neutron subnet-create --name nova --enable_dhcp=False --allocation-pool=start=10.1.1.51,end=10.1.1.250 --gateway=10.1.1.1 nova 10.1.1.0/24

echo "CREATING ROUTERS"
neutron router-create web_router
neutron router-create app_router
neutron router-create db_router
neutron router-create dev_router
neutron router-create utility_router

echo "SETTING ROUTER GATEWAYS"
neutron router-gateway-set web_router nova
neutron router-gateway-set app_router nova
neutron router-gateway-set db_router nova
neutron router-gateway-set dev_router nova
neutron router-gateway-set utility_router nova

echo "CONFIGURING ROUTER INTERFACES"
neutron router-interface-add web_router web
neutron router-interface-add app_router app
neutron router-interface-add db_router db
neutron router-interface-add dev_router dev
neutron router-interface-add dev_router utility

echo "CONFIGING FLAVORS"

openstack flavor create --public micro --id 00 --ram 128 --swap 128 --ephemeral 0 --disk 1 --vcpus 1
openstack flavor create --public kilo-1-tiny --id 0 --ram 256 --swap 256 --ephemeral 1 --disk 1 --vcpus 1
openstack flavor create --public kilo-1-20 --id 1 --ram 20480 --swap 256 --ephemeral 1 --disk 10 --vcpus 1
openstack flavor create --public kilo-1-40 --id 2 --ram 40960 --swap 256 --ephemeral 1 --disk 10 --vcpus 1
openstack flavor create --public kilo-2-40 --id 3 --ram 40960 --swap 256 --ephemeral 1 --disk 10 --vcpus 2
openstack flavor create --public kilo-2-80 --id 4 --ram 81920 --swap 256 --ephemeral 1 --disk 10 --vcpus 2
openstack flavor create --public mega-2-16 --id 5 --ram 16384 --swap 256 --ephemeral 1 --disk 10 --vcpus 2
openstack flavor create --public mega-4-16 --id 6 --ram 16384 --swap 256 --ephemeral 1 --disk 10 --vcpus 4
openstack flavor create --public mega-4-32 --id 7 --ram 32768 --swap 256 --ephemeral 1 --disk 10 --vcpus 4
openstack flavor create --public mega-8-32 --id 8 --ram 32768 --swap 256 --ephemeral 1 --disk 10 --vcpus 8
openstack flavor create --public mega-8-64 --id 9 --ram 65536 --swap 256 --ephemeral 1 --disk 10 --vcpus 8

echo "Update Project: ADMIN Quotas"

nova quota-class-update --instances 100 default
nova quota-class-update --cores 100 default

echo "Defining Network Environmental Values"

web_id=$(neutron net-list | awk '$4 == "web" {print $2}')
app_id=$(neutron net-list | awk '$4 == "app" {print $2}')
db_id=$(neutron net-list | awk '$4 == "db" {print $2}')
dev_id=$(neutron net-list | awk '$4 == "dev" {print $2}')
utility_id=$(neutron net-list | awk '$4 == "utility" {print $2}')

echo "BUILD TEST INSTANCES"

for i in {1..2}; do nova boot --flavor micro --nic net-id=$web_id --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key web$i; done
for i in {1..1}; do nova boot --flavor micro --nic net-id=$app_id --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key app$i; done
for i in {1..1}; do nova boot --flavor micro --nic net-id=$db_id --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key db$i; done
for i in {2..8}; do nova boot --flavor micro --nic net-id=$dev_id --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key dev$i; done
for i in {1..1}; do nova boot --flavor micro --nic net-id=$utility_id --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key calamari$i; done
for i in {1..1}; do nova boot --flavor micro --nic net-id=$utility_id --image cirros-0.3.3-x86_64 -1security-group default --key-name demo-key logging$i; done
for i in {1..1}; do nova boot --flavor micro --nic net-id=$utility_id --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key goldstone$i; done
