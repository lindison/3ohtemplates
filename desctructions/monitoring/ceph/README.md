# Ceph Monitoring

Calamari can be used to monitor CEPH  

## Calamari

Installing using a Docker Container  

Pull the docker image  

`docker pull kairen/docker-calamari-server:1.3.1`  

Run the Docker Image  

`docker run -d -p 80:80 -p 4505:4505 -p 4506:4506 -ti \
--name calamari-server kairen/docker-calamari-server:1.3.1 -d`  

Open a browser to the website defined above.  
Default username and password is `admin` and `admin`  

## Configuring Calamari to work with CEPH  
