# Start install of Undercloud

`echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf`
`hostnamectl set-hostname undercloud.local.com`
`hostnamectl set-hostname --transient undercloud.local.com`

## Update transient name to /etc/hosts file

Update the hostname to reflect the name used in the above section.  

`vi /etc/hosts`  (example: 127.0.0.1 undercloud.local.com)

## Register the RHEL-7 box to Red Hat.

Register the box to subscription manager. This requires the account name and password that is used with the Red Hat subscription.  
`subscription-manager register`  

The following will list the available subscriptions to the account used above. This command will output a ton of stuff, look for the subscription called "Red Hat OpenStack."  
`subscription-manager list --available`

For the purposes of the "demo" the following pool is used. Update this according to your entilement.  
`subscription-manager subscribe --pool=8a85f98155e9947d0155ea71bc2b1389`  

Disable all the yum repos; in the next step we'll re-enable only the ones needed.  
`subscription-manager repos --disable=*`   

Enable only the repos required for install the undercloud and other RHEL tools.
`subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-openstack-8-rpms --enable=rhel-7-server-openstack-8-director-rpms --enable rhel-7-server-rh-common-rpms`  

### Update the system.  

Update system and install packages.  
`sudo yum install -y elinks`  

`sudo yum update -y`  

`sudo reboot`  

## Create the stack user account.

This is an account used by the UnderCloud to provision the overcloud.  
`useradd stack`  

`echo "stack:redhat" | chpasswd`  

`echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack`  

`chmod 0440 /etc/sudoers.d/stack`  

### Login as stack user
`su - stack`

`cd ~`

### Create Directories for holding templates and images.   

`mkdir images`  

`mkdir templates`  

### Install the tripleO client.

`sudo yum install -y python-tripleoclient`  

### Need to determine if this needs to be done to resolve the Horizon issue.

If Horizon is unable to deploy properly when running the overcloud deployment, this downgrade may resolve the issue. By default, use the installed package and only down grade as a trouble shooting step.  
(source: https://bugzilla.redhat.com/show_bug.cgi?id=1347063)  
`sudo yum downgrade python-tripleoclient-0.3.4-4.el7ost.noarch`

### Need to check this fix if needed with physicals
When the undercloud reboots; it may go into a emergency boot state. This is the fix.

`https://access.redhat.com/solutions/1437183`  

### Put customer specific config in here {{ undercloud.conf }}
This is the undercloud configurations. The tripeO undercloud will be installed using these settings.  

`vi undercloud.conf`  

### Install the undercloud

`openstack undercloud install`

### Validate undercloud is installed

This can be added to a typical bashrc file, if desired. Source the file to get the OpenStack credentials.

`source ~/stackrc`   

This should show services running   

`openstack-status`   

This should show ...  

`openstack catalog show nova`   

## END UnderCloud Installed
---

### Prepare undercloud for deploying overcloud

`sudo yum -y install rhosp-director-images rhosp-director-images-ipa`  

`cp /usr/share/rhosp-director-images/overcloud-full-latest-8.0.tar ~/images/.`  

`cp /usr/share/rhosp-director-images/ironic-python-agent-latest-8.0.tar ~/images/.`  

`cd ~/images`   

`for tarfile in *.tar; do tar -xf $tarfile; done`   

`openstack overcloud image upload --image-path /home/stack/images`   

### Validate images are uploaded

`openstack image list`   

### Check neutron dns

`neutron subnet-list`   

### Need id and customer specific DNS server

`neutron subnet-update {{ subnet_id }} --dns-nameserver 10.0.0.2`   

### Create the json (refer to create_json_kvm doc)
### instructions are in instack_json_kvm.txt

### Validate the json
`curl -O https://raw.githubusercontent.com/rthallisey/clapper/master/instackenv-validator.py`  

`python instackenv-validator.py -f instackenv.json`  

### Add nodes to Ironic

`openstack baremetal import --json instackenv.json`  

### Show nodes registered

`ironic node-list`  

### Create flavors (as needed)

`openstack flavor create --id auto --ram 8192 --disk 58 --vcpus 1 kvm-baremetal`  

`openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" kvm-baremetal`  

`openstack baremetal configure boot`  

`openstack baremetal introspection bulk start`  

### Tag nodes

`ironic node-update 4ef3ef19-f846-4c8d-a9fe-8778550e3ad9 add properties/capabilities='profile:compute,boot_option:local'`

`ironic node-update 9f74d16f-0aa8-4ceb-8d4d-aa65af99549a add properties/capabilities='profile:control,boot_option:local'`

`openstack overcloud profiles list`

### Configure yml files:
Will add more customer specific YAML files to the SCM.  

`vi templates/network-environment.yaml`  
`vi templates/nic-configs/controller.yaml`  

`openstack overcloud deploy --templates --control-scale 1 --compute-scale 1 --neutron-tunnel-types vxlan --neutron-network-type vxlan`  

`openstack overcloud deploy --templates -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e ~/templates/network-environment.yaml -e ~/templates/firstboot-environment.yaml --control-scale 1 --compute-scale 1 --control-flavor control --compute-flavor compute --ntp-server pool.ntp.org --neutron-network-type vxlan --neutron-tunnel-types vxlan`  
