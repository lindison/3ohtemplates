#!/bin/bash

source ~/overcloudrc

echo START BUILD NETWORKS

neutron net-create application
neutron subnet-create --name application --gateway 172.16.2.1 application 172.16.2.0/23
neutron net-create database
neutron subnet-create --name database --gateway 172.16.4.1 database 172.16.4.0/23
neutron net-create web
neutron subnet-create --name web --gateway 172.16.6.1 web 172.16.6.0/23
neutron net-create nova --router:external --provider:network_type flat --provider:physical_network datacentre
neutron subnet-create --name nova --enable_dhcp=False --allocation-pool=start=10.1.1.51,end=10.1.1.250 --gateway=10.1.1.1 nova 10.1.1.0/24

echo "START BUILD ROUTER"

neutron router-create router1
neutron router-gateway-set router1 nova

echo "CREATE ROUTER INTERFACES"

neutron router-interface-add router1 web
neutron router-interface-add router1 application
neutron router-interface-add router1 database

echo "START BUILD FLAVORS"

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
