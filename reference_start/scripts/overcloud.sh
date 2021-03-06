#! /bin/bash

openstack overcloud deploy --templates --validation-errors-fatal --validation-warnings-fatal \
          --control-flavor control --compute-flavor compute --ceph-storage-flavor ceph-storage \
	  --control-scale 1 --compute-scale 2 --ceph-storage-scale 4 \
	  --block-storage-scale 0 --swift-storage-scale 0 \
	  -e /home/stack/templates/storage-environment.yaml \
	  -e /home/stack/templates/net-bond-with-vlans.yaml \
	  -e /home/stack/templates/timezone.yaml \
	  --ntp-server 10.110.31.205 	  


