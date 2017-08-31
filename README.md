# Jupyterhub Docker Service

A pip based system to run Jupyterhub as a Docker service.
Serving up single user jupyter servers as docker services.

Based on [jupyterhub](https://github.com/jupyterhub/jupyterhub) and [SwarmSpawner](https://github.com/cassinyio/SwarmSpawner)

## What it Gives You

* Jupyterhub running as a docker service
* Serves up single user Jupyter server with a prebuilt Python/R image  

## Basic Use

* Clone the repo and build the images 

```
git clone <repo>
cd Jupyterhub-Swarm
docker build -t jupyterpip .
cd pip-notebook
docker build -t jupyter/pip-notebook
cd ..
```

* Initialize the docker swarm
```
docker swarm init --advertise-addr <ip-addr-master> 
```

* Create the overlay network for the services
```
./network.sh
```

* Start the jupyterhub service
```
./jupyterpip.sh
```

* Open the hub in a browser and log in as a linux user from the master host
```
firefox http://<ip-addr-master>:8000
```

* Once you are logged in click Start Server

* If everything has worked your Jupyter server should spawn
