#!/bin/bash
docker service create \
	--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
	--mount type=bind,src=/usr/bin/docker,dst=/usr/bin/docker \
	--mount type=bind,src=/etc/passwd,dst=/etc/passwd \
	--mount type=bind,src=/etc/shadow,dst=/etc/shadow \
	--mount type=bind,src=/etc/group,dst=/etc/group \
	--mount type=bind,src=/etc/gshadow,dst=/etc/gshadow \
	--name jupyterpip \
	--publish 8000:8000 \
	--network jupyterhub jupyterpip

