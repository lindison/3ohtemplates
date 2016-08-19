#! /bin/bash

# this creates the floating network and router
. ~stack/overcloudrc

neutron net-create --provider:network_type=vlan --router:external --provider:physical_network=datacentre --provider:segmentation_id=3102  floating


neutron subnet-create --name floating --enable_dhcp=False \
  --allocation-pool start=10.110.200.130,end=10.110.200.240 \
  --dns-nameserver 8.8.8.8 --gateway 10.110.200.1 \
  floating 10.110.200.0/24

neutron router-create router1

neutron router-gateway-set router1 floating

