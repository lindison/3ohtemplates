# SolidFire configuration in Cinder

## Cinder updates for the SolidFire Driver

http://docs.openstack.org/liberty/config-reference/content/solidfire-volume-driver.html

The SolidFire Cluster is a high performance all SSD iSCSI storage device that provides massive scale out capability and extreme fault tolerance. A key feature of the SolidFire cluster is the ability to set and modify during operation specific QoS levels on a volume for volume basis. The SolidFire cluster offers this along with de-duplication, compression, and an architecture that takes full advantage of SSDs.

To configure the use of a SolidFire cluster with Block Storage, modify your cinder.conf file as follows:

volume_driver = cinder.volume.drivers.solidfire.SolidFireDriver  
san_ip = 172.17.1.182         # the address of your MVIP  
san_login = sfadmin           # your cluster admin login  
san_password = sfpassword     # your cluster admin password  
sf_account_prefix = ''        # prefix for tenant account creation on solidfire cluster  
