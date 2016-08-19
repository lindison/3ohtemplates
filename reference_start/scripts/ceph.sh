#! /bin/bash

for i in rbd images volumes vms ; do
  ceph osd pool set $i pg_num 512
sleep 15
  ceph osd pool set $i pgp_num 512
done

