FROM ubuntu:16.04 
MAINTAINER Jupyter Project <jupyter@googlegroups.com>

# install nodejs, utf8 locale, set CDN because default httpredir is unreliable
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install locales git bzip2 && \
    /usr/sbin/update-locale LANG=C.UTF-8 && \
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_TYPE=en_US.UTF-8

RUN apt-get install -y npm nodejs-legacy
RUN apt-get install -y python3 python3-dev python3-pip
RUN npm install -g configurable-http-proxy
RUN pip3 install --upgrade pip 
#RUN pip3 install --upgrade notebook
RUN pip3 install jupyterhub
#RUN jupyter serverextension enable --py jupyterlab --sys-prefix

#RUN mkdir -p /src/SwarmSpawner
#WORKDIR /src/SwarmSpawner
#RUN git clone https://github.com/cassinyio/SwarmSpawner .
ADD SwarmSpawner /src/SwarmSpawner
WORKDIR /src/SwarmSpawner
RUN python3.5 setup.py install 

WORKDIR /srv/jupyterhub/
EXPOSE 8000
LABEL org.jupyter.service="jupyterhub"

ADD config /srv/jupyterhub
CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
