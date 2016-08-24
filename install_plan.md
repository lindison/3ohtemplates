# POC OpenStack Install

Author: Lindison Webb  
Customer:  

## Software List  

Software | Name | Repo | Install Method
--- | --- | --- | ---
TripleO UnderCloud | python-tripleo | Red Hat | yum
ROSP 8 | OpenStack | Red Hat | yum
Ansible | Ansible | Ansible | git
Docker | Docker | Docker | pip


## Pre-flight checks

Validate ability to log into system  
Validate network connectivity to the UnderCloud node  
Validate network connectivity to the Internet from the UnderCloud node  
Validate the system is registered  
Validate the /etc/hosts contains the system's hostname  
Validate the RH subscription  
Disable all Repos  
Enable only the needed Repos  
Validate the network configuration on the UnderCloud node  
Validate the network configuration on the target nodes
Run yum update and reboot the system  

## Create the Stack user
Create the stack user  
su to the stack user  
create two directories (templates and images)  

## Install the python-tripleO packages  

Install this package from the stack user.  

## Configure the undercloud.conf file  

This file should be versioned controlled.  

This file needs to be pre-defined with the details of the undercloud.  
IP Addresses, Network CIDR, DNS Servers, User Names, and Passwords get
defined in this file.  

The UnderCloud installer will pull its configuration from this file.  

## Install the UnderCloud  

As the stack user, run the undercloud install  
*This may take 30-60 minutes*  

## Validate the undercloud is install  

cat the ~/stackrc file  
run `nova list`  
run `ironic node-list`  

## Import the physical nodes  

Use the "instack_json_bm.md" reference to run this.  
Check the instack json syntax using check-json  
Run the openstack baremetal import function  
Run ironic node-list  
Run introspection  

## Configure install parameters

Configure flavors and profiles  
Assign profiles to nodes  
Configure YAML files  

## Install OverCloud

Update build_overcloud.sh  
Install OverCloud using build_overcloud.sh  

## Log into OverCloud

Log into OverCloud using heat-admin account from UnderCloud  

## Check the CEPH node  

Log into the OverCloud CEPH node using the head-admin  
Test the CEPH node (ceph health)  

## Install test glance image cirros  

Download the image and register the image with glance  

## configure overcloud and run test  

Update the config-overcloud.sh script  
Run the config-overcloud.sh script  
