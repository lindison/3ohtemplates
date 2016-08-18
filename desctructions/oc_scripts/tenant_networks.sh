#!/bin/bash

source ~/overcloudrc
neutron net-create default
neutron subnet-create --name default --gateway 172.16.0.1 default 172.16.0.0/23
neutron net-create application
neutron subnet-create --name application --gateway 172.16.2.1 application 172.16.2.0/23
neutron net-create database
neutron subnet-create --name database --gateway 172.16.4.1 database 172.16.4.0/23
neutron net-create web
neutron subnet-create --name web --gateway 172.16.6.1 web 172.16.6.0/23
neutron net-create nova --router:external --provider:network_type flat --provider:physical_network datacentre
neutron subnet-create --name nova --enable_dhcp=False --allocation-pool=start=10.1.1.51,end=10.1.1.250 --gateway=10.1.1.1 nova 10.1.1.0/24
