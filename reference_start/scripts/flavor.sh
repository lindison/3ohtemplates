#! /bin/bash

# This script deletes standard flavors
# and creates the customer requested flavors
. ~stack/overcloudrc

for i in 1 2 3 4 5 ; do
nova flavor-delete $i
done

openstack flavor create --id 1 --ram 3072 --disk 10 --ephemeral 0 --vcpus 2 --public m1.medium
openstack flavor create --id 2 --ram 8192 --disk 10 --ephemeral 0 --vcpus 4 --public m1.large
