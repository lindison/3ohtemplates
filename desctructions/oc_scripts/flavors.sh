#!/bin/bash

source ~/overcloudrc
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
