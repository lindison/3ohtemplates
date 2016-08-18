# EMC XIO configuration in Cinder

## Cinder updates for the EMC XIO Driver

http://docs.openstack.org/liberty/config-reference/content/XtremIO-cinder-driver.html

[Default]  
enabled_backends = XtremIO  

[XtremIO]  
volume_driver = cinder.volume.drivers.emc.xtremio.XtremIOFibreChannelDriver  
san_ip = XMS_IP  
xtremio_cluster_name = Cluster01  
san_login = XMS_USER  
san_password = XMS_PASSWD  
volume_backend_name = XtremIOAFA  
