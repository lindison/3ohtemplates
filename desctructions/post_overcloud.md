# Post OverCloud install

## Set Quotas

`nova quota-class-update --instances 100 default`

`nova quota-class-update --cores 100 default`

## Check CEPH  

SSH to Ceph node  

On the undercloud:  
`nova list`

+--------------------------------------+-------------------------+--------+------------+-------------+--------------------+
| ID                                   | Name                    | Status | Task State | Power State | Networks           |
+--------------------------------------+-------------------------+--------+------------+-------------+--------------------+
| 56336574-d1d6-4e07-8c57-c4c502421e52 | overcloud-cephstorage-0 | ACTIVE | -          | Running     | ctlplane=10.0.0.14 |
| df4828f2-2ebf-4103-8f0e-7bc539ce4dc2 | overcloud-cephstorage-1 | ACTIVE | -          | Running     | ctlplane=10.0.0.21 |
| 800fcdb1-f763-4564-a5ed-73fad8df642e | overcloud-cephstorage-2 | ACTIVE | -          | Running     | ctlplane=10.0.0.15 |

SSH to cephstorage-0, for this example:  
`ssh heat-admin@10.0.0.14`  

Once logged, do a CEPH health check.  

`source overcloudrc`  

`sudo ceph health`  

`sudo ceph df`  

`sudo ceph pg stat`  

`sudo ceph status`  

`sudo ceph auth list`  

`sudo ceph mon stat`  

`sudo ceph quorum_status -f json-pretty`  

`sudo ceph osd tree`  

`sudo ceph osd blacklist ls`  

`sudo ceph osd crush rule list`  

`sudo ceph osd find 1`

`sudo ceph osd find 2`



## Create the OpenStack Tenant Networks   

Either the overcloudnetwork.sh script can be run; or the below commands can be run to do the one offs.

$ `./build_overcloud.sh`  

This scipt will build the overcloud.  

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

`curl -O http://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img`   
`glance --os-image-api-version 2 image-create --name "cirros-0.3.3-x86_64" --disk-format qcow2 --container-format bare --visibility public --file cirros-0.3.3-x86_64-disk.img --progress`

`glance image-list`  
`nova image-list`  
`ssh-keygen -q -N ""`  
`nova keypair-add --pub-key ~/.ssh/id_rsa.pub demo-key`  

`for i in {1..2}; do nova boot --flavor kilo-1-tiny --nic net-id=695ad094-a6c5-4134-99fa-acbea463ab71 --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key web$i; done`  

`for i in {1..2}; do nova boot --flavor kilo-1-tiny --nic net-id=d8796edd-2422-439a-8c05-f23d4f82ff3a --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key app$i; done`

`for i in {1..1}; do nova boot --flavor kilo-1-tiny --nic net-id=4eb7febc-419d-413b-ac6f-0b7309f40236 --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key db$i; done`

`for i in {1..1}; do nova boot --flavor kilo-1-tiny --nic net-id=c204c9b5-e825-4a87-84c3-3612694dea8f --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key dev$i; done`

 `for i in {1..1}; do nova boot --flavor kilo-1-tiny --nic net-id=e8ec2f9d-fa87-408e-9d70-acc83b64fa58 --image cirros-0.3.3-x86_64 --security-group default --key-name demo-key backup$i; done`

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


## OS (assume 64bit on all):

### Building Images
http://docs.openstack.org/image-guide/centos-image.html
http://docs.openstack.org/image-guide/ubuntu-image.html
https://www.rdoproject.org/resources/image-resources/

### Finding and installing cloud ready images

 http://docs.openstack.org/image-guide/obtain-images.html link for images
[Red Hat Enterprise Linux 6 (x86_64)](https://rhn.redhat.com/rhn/software/channel/downloads/Download.do?cid=16952)  
`curl -O`  
`tar -xvzf  `
`glance --os-image-api-version 2 image-create --name 'name' --disk-format qcow2 --container-format bare --visibility public --file file --progress`  

[Red Hat Enterprise Linux 7 (x86_64)](https://access.redhat.com/downloads/content/69/ver=/rhel---7/x86_64/product-downloads)  
`curl -O`  
`tar -xvzf  `
`glance --os-image-api-version 2 image-create --name 'name' --disk-format qcow2 --container-format bare --visibility public --file file --progress`  

[Ubuntu 14.04](http://cloud-images.ubuntu.com/trusty/)  
`curl -O http://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64.tar.gz`  
`tar -xvzf `
`glance --os-image-api-version 2 image-create --name 'Ubuntu-1404-x86_64' --disk-format qcow2 --container-format bare --visibility public --file trusty-server-cloudimg-amd64.img --progress`  

[CentOS 6 (x86_64)](http://cloud.centos.org/centos/6/images/)  
`curl -O http://cloud.centos.org/centos/6/images/CentOS-6-x86_64-GenericCloud.qcow2`  
`glance --os-image-api-version 2 image-create --name 'CentOS-6-x86_64' --disk-format qcow2 --container-format bare --visibility public --file CentOS-6-x86_64-GenericCloud.qcow2 --progress`

[CentOS 7 (x86_64)](http://cloud.centos.org/centos/7/images/)  
`curl -O http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2`  
`glance --os-image-api-version 2 image-create --name 'CentOS-7-x86_64' --disk-format qcow2 --container-format bare --visibility public --file trusty-server-cloudimg-amd64.img --progress`  

[Windows Server 2012 R2(x86_64)](https://cloudbase.it/windows-cloud-images/)  

Oracle Enterprise Linux (x86_64)
This can be done using the building cloud images from above  

Examples:  
'source overcloudrc'  
'curl -O https://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/fedora/linux/releases/23/Cloud/x86_64/Images/Fedora-Cloud-Base-23-20151030.x86_64.qcow2'  

### To make the image visible outside project, the image must be created by the admin.

`glance --os-image-api-version 2 image-create --name 'Fedora-23-x86_64' --disk-format qcow2 --container-format bare --visibility public --file Fedora-Cloud-Base-23-20151030.x86_64.qcow2 --progress`
