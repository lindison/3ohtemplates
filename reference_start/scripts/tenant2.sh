#! /bin/bash

. ~stack/overcloudrc

openstack project create tenant2
openstack user create tenant2 --password password2

openstack role create user

openstack role add --project tenant2 --user tenant2 user

source <( openstack project show tenant2 -f shell) 


neutron net-create --provider:network_type=vlan --provider:physical_network=datacentre --provider:segmentation_id=3105 --tenant_id=$id tenant2net1

neutron subnet-create --name=tenant2subnet1 --dns-nameserver=8.8.8.8 --tenant_id=$id tenant2net1 172.16.40.0/24

neutron router-interface-add router1 tenant2subnet1

. ~stack/scripts/tenant2rc
openstack security group rule create --proto tcp --dst-port 1:65535 default
openstack security group rule create --proto udp --dst-port 1:65535 default
openstack security group rule create --proto icmp --dst-port -1 default


openstack security group create --description "Sample Webserver" webserver
openstack security group rule create --proto tcp --dst-port 22:22 webserver
openstack security group rule create --proto tcp --dst-port 80:80 webserver
openstack security group rule create --proto tcp --dst-port 443:443 webserver
openstack security group rule create --proto tcp --dst-port 8080:8080 webserver
openstack security group rule create --proto tcp --dst-port 8443:8443 webserver
openstack security group rule create --proto icmp --dst-port -1 webserver

openstack security group create --description "SSH Only" sshonly
openstack security group rule create --proto tcp --dst-port 22:22 sshonly
openstack security group rule create --proto icmp --dst-port -1 sshonly

