# This is the plan that I'm working with.

1) Build the undercloud and update the dns name server on the subnets
  - update the undercloud box RH subscription
  - disable repos and enable OSP repos only
  - install the pre-reqs on the undercloud box
  - configure the undercloud.conf file
  - run the install of the undercloud
2) Download the images
3) configure the KVM box for working with OpenStack
  - configure the networks
    -  00-PXE Network
    -  20-MGMT Network
    -  40-STORAGE Network
    -  60-TENANT Network
    -  80-ILO Network
    -  98-OUTSIDE Network
    -  99-PUBLIC Network
    -  99-STORAGE_MGMT Network
  - configure the access for Undercloud to OpenStack
  - build the target PXE boxes
5) Configure the UnderCloud to use pxe_ssh with the KVM Boxes
  - Create a service /usr/bin/bootif-fix
  - Start /usr/bin/bootif-fix service
6) Configure the instackenv.json using jq
  - use virsh to pull the mac addresses of the interface on 00-PXE for the PXE boxes
  - build the instackenv.json using jq
7) Import the PXE Boxes into Ironic
8) Change the timeout values on the UnderCloud server for using KVM
9) Create the correct flavors
10) Run OpenStack Configure boot
11) Perform introspection of the PXE Boxes
12) Tag the nodes with profiles
13) Update the heat templates
  - http://jodies.de/ipcalc?host=64.106.128.129&mask1=27&mask2=
14) Run the openstack overcloud deploy using the heat templates
  - controller = 1 , compute = 1
15) Login and validate the system is running
16) Scale the openstack overcloud deploy
  - controller = 1 , compute = 4
