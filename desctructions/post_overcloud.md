# Post OverCloud install

## Create the OpenStack Tenant Networks   

Either the overcloudnetwork.sh script can be run; or the below commands can be run.

neutron net-create <name>  
`neutron net-create default`
`neutron net-create application`
`neutron net-create database`
`neutron net-create web`
`neutron subnet-create --name default --gateway 172.16.0.1 default 172.16.0.0/23`  
`neutron subnet-create --name application --gateway 172.16.2.1 application 172.16.2.0/23`  
`neutron subnet-create --name database --gateway 172.16.4.1 database 172.16.4.0/23`  
`neutron subnet-create --name web --gateway 172.16.6.1 web 172.16.6.0/23`  

[heat-admin@overcloud-controller-0 ~]$ neutron net-list  
+--------------------------------------+---------+----------------------------------------------------+  
| id                                   | name    | subnets                                            |  
+--------------------------------------+---------+----------------------------------------------------+  
| 35f906d7-e7c2-4ade-9951-c6e995d10cb6 | default | 80de388e-62c4-49b2-a3f5-e0850ce6a025 172.20.0.0/16 |  
|                                      |         | 213c1b03-065b-4a5b-b2ed-91890a5fa4b3 172.21.0.0/16 |  
|                                      |         | 41bd05fe-1afa-4b7c-b3d9-394e8cbce31a 172.23.0.0/16 |  
|                                      |         | 01f70ff6-7324-496c-9734-c68ef9b13362 172.22.0.0/16 |  
+--------------------------------------+---------+----------------------------------------------------+  

## Create external network

`neutron net-create nova --router:external --provider:network_type flat --provider:physical_network datacentre`  

`neutron subnet-create --name nova --enable_dhcp=False --allocation-pool=start=10.1.1.51,end=10.1.1.250 --gateway=10.1.1.1 nova 10.1.1.0/24`  

## Create routers

neutron router-create <name>  
`neutron router-create router1`

neutron router-gateway-set <router_id> <external_network_id>  
`neutron router-gateway-set 983714c7-f129-41bd-af24-7a94ac5a7661 d8f96f46-b970-4bc5-adc2-03d41795bf28`

## Download and install the Cirros test image

`yum install -y wget`  
`mkdir /tmp/images`  
`wget -P /tmp/images http://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img`  
`glance image-create --name "cirros-0.3.3-x86_64" --file /tmp/images/cirros-0.3.3-x86_64-disk.img   --disk-format qcow2 --container-format bare --visibility public --progress`  
`glance image-list`  
`nova image-list`  
`ssh-keygen -q -N ""`  
`nova keypair-add --pub-key ~/.ssh/id_rsa.pub demo-key`  
`for i in {1..3}; do nova boot --flavor kilo-1-tiny --nic net-id=843a394c-f23d-47f7-8d00-8215142cea13 --nic net-id=faef487b-9bff-4e28-981c-099ae841bf19 --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key demo-instance$i; done`  

`for i in {1..3}; do nova boot --flavor kilo-1-tiny --nic net-id=b33f7859-11f3-43e0-aef3-d5e56fe8f4a1 --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key demo-instance$i; done`

`for i in {1..3}; do nova boot --flavor kilo-1-tiny --nic net-id=faef487b-9bff-4e28-981c-099ae841bf19 --nic net-id=843a394c-f23d-47f7-8d00-8215142cea13 --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key demo-instance$i; done`


[heat-admin@overcloud-controller-0 ~]$ nova list  
+--------------------------------------+-----------------+--------+------------+-------------+----------+  
| ID                                   | Name            | Status | Task State | Power State | Networks |  
+--------------------------------------+-----------------+--------+------------+-------------+----------+  
| 0ac16b13-003b-437b-94e6-c7f72b0a686d | demo-instance1  | ACTIVE | -          | Running     |          |  
| 4db4262b-9acd-4189-97fa-ae364200e323 | demo-instance10 | BUILD  | spawning   | NOSTATE     |          |  
| a2efd437-1b96-4a94-bfed-a899e2ad1652 | demo-instance2  | ACTIVE | -          | Running     |          |  
| 84ccac59-b2b7-4490-888a-afd30d5d278b | demo-instance3  | ACTIVE | -          | Running     |          |  
| 0d42329a-d913-410b-84fa-ba1861bd0229 | demo-instance4  | ACTIVE | -          | Running     |          |  
| fca65c38-ba78-48be-ae08-b04ef9bc5647 | demo-instance5  | ACTIVE | -          | Running     |          |  
| 579bbd01-7c92-4689-8410-cfa678eb3a71 | demo-instance6  | ACTIVE | -          | Running     |          |  
| 7ddea225-3779-455f-b4de-dbe21d7981f1 | demo-instance7  | ACTIVE | -          | Running     |          |  
| af6a32f8-f2a8-4479-8d83-7ceda932476e | demo-instance8  | ACTIVE | -          | Running     |          |  
| 617a8d57-67d4-471c-8155-b6a2da903614 | demo-instance9  | ACTIVE | -          | Running     |          |  
+--------------------------------------+-----------------+--------+------------+-------------+----------+  
[heat-admin@overcloud-controller-0 ~]$ for i in {1..10}; do nova delete demo-instance$i; done  
[heat-admin@overcloud-controller-0 ~]$ nova list  
+----+------+--------+------------+-------------+----------+  
| ID | Name | Status | Task State | Power State | Networks |  
+----+------+--------+------------+-------------+----------+  
+----+------+--------+------------+-------------+----------+  

### Flavors:

Create flavors with the following commands, --id can be declarative (preferred) or automatic:  

Kilo-1-20, 1vCPU, 20GB RAM  
`openstack flavor create --public kilo-1-20 --id 1 --ram 20480 --disk 40 --vcpus 1`  
Kilo-1-40, 1vCPU, 40GB RAM  
`openstack flavor create --public kilo-1-40 --id 2 --ram 40960 --disk 40 --vcpus 1`  
Kilo-2-40, 2vCPU, 40GB RAM  
`openstack flavor create --public kilo-2-40 --id 3 --ram 40960 --disk 40 --vcpus 2`  
Kilo-2-80, 2vCPU, 80GB RAM  
`openstack flavor create --public kilo-2-80 --id 4 --ram 81920 --disk 40 --vcpus 2`   
Mega-2-16, 2vCPU, 16GB RAM  
`openstack flavor create --public mega-2-16 --id 5 --ram 16384 --disk 40 --vcpus 2`  
Mega-4-16, 4vCPU, 16GB RAM  
`openstack flavor create --public mega-4-16 --id 6 --ram 16384 --disk 40 --vcpus 4`  
Mega-4-32, 4vCPU, 32GB RAM  
`openstack flavor create --public mega-4-32 --id 7 --ram 32768 --disk 40 --vcpus 4`  
Mega-8-32, 8vCPU, 32GB RAM  
`openstack flavor create --public mega-8-32 --id 8 --ram 32768 --disk 40 --vcpus 8`  
Mega-8-64, 8vCPU, 64GB RAM  
`openstack flavor create --public mega-8-64 --id 9 --ram 65536 --disk 40 --vcpus 8`  

[heat-admin@overcloud-controller-0 ~]$ nova flavor-list
+--------------------------------------+-----------+-------+------+-----------+-------+-----------+
| ID                                   | Name      |   RAM | Disk | Ephemeral | VCPUs | Is Public |
+--------------------------------------+-----------+-------+------+-----------+-------+-----------+
| 0b408f91-0eea-4cf9-9032-e646603ec1e7 | mega-8-64 | 65536 |   40 |         0 |     8 | True      |
| 337ea328-6ff4-45d8-9c72-867042e15386 | kilo-2-40 | 40960 |   40 |         0 |     2 | True      |
| 3d5bfc0d-03a8-48dc-92c1-8e15b24781b2 | mega-2-16 | 16384 |   40 |         0 |     2 | True      |
| 6becb8d7-14f1-47fe-b6ae-326bb462c4a8 | mega-4-16 | 16384 |   40 |         0 |     4 | True      |
| 741d1304-2717-429d-a2f3-d94ac27e273f | mega-4-32 | 32768 |   40 |         0 |     4 | True      |
| 8945c0bc-1841-40f7-8e14-9f1f386b0ae1 | kilo-1-20 | 20480 |   40 |         0 |     1 | True      |
| b0d8d110-2369-4009-aa44-021429394ba6 | kilo-2-80 | 81920 |   40 |         0 |     2 | True      |
| cd20b188-d7c8-4877-8d53-3f0846056437 | kilo-1-40 | 40960 |   40 |         0 |     1 | True      |
| e8fa6fa2-49fb-49ea-b7ef-a50fccd58aab | mega-8-32 | 32768 |   40 |         0 |     8 | True      |
+--------------------------------------+-----------+-------+------+-----------+-------+-----------+


## OS (assume 64bit on all):

### Building Images
http://docs.openstack.org/image-guide/centos-image.html
http://docs.openstack.org/image-guide/ubuntu-image.html
https://www.rdoproject.org/resources/image-resources/

### Finding and installing cloud ready images

 http://docs.openstack.org/image-guide/obtain-images.html link for images
[Red Hat Enterprise Linux 6 (x86_64)](https://rhn.redhat.com/rhn/software/channel/downloads/Download.do?cid=16952)  
[Red Hat Enterprise Linux 7 (x86_64)](https://access.redhat.com/downloads/content/69/ver=/rhel---7/x86_64/product-downloads)  
[Ubuntu 14.04](http://cloud-images.ubuntu.com/trusty/)  
[CentOS 6 (x86_64)](http://cloud.centos.org/centos/6/images/)  
[CentOS 7 (x86_64)](http://cloud.centos.org/centos/7/images/)  
[Windows Server 2012 R2(x86_64)](https://cloudbase.it/windows-cloud-images/)  
Oracle Enterprise Linux (x86_64)
This may need to be done using Packer (out of scope for POC?)

Examples:  
'source overcloudrc'  
'curl -O https://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/fedora/linux/releases/23/Cloud/x86_64/Images/Fedora-Cloud-Base-23-20151030.x86_64.qcow2'  

### To make the image visible outside project, the image must be created by the admin.

'glance --os-image-api-version 2 image-create --name 'Fedora-23-x86_64' --disk-format qcow2 --container-format bare --visibility public --file Fedora-Cloud-Base-23-20151030.x86_64.qcow2'  
