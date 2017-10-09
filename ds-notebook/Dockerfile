# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Ubuntu 16.04 (xenial) from 2017-07-23
# https://github.com/docker-library/official-images/commit/0ea9b38b835ffb656c497783321632ec7f87b60c
#FROM ubuntu@sha256:84c334414e2bfdcae99509a6add166bbb4fa4041dc3fa6af08046a66fed3005f
FROM ubuntu:16.04

MAINTAINER Jupyter Project <jupyter@googlegroups.com>

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Configure environment
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get -y install python3 python3-dev python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir notebook jupyterhub jupyterlab virtualenv
RUN jupyter serverextension enable --py jupyterlab --sys-prefix

RUN apt-get -y install python python-dev python-pip
RUN virtualenv py27 --python=python2.7
RUN . /py27/bin/activate; pip install --no-cache-dir ipykernel
RUN . /py27/bin/activate; python -m ipykernel install --name py27 --display-name "Python 2.7"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
RUN apt-get update
RUN apt-get -y install r-base r-base-dev
EXPOSE 8888

# Configure container startup
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

COPY install.r /tmp/R/
RUN R -f /tmp/R/install.r
RUN mv /root/.local/share/jupyter/kernels/ir/ /usr/local/share/jupyter/kernels/

RUN apt-get -y update
RUN apt-get install -y gdebi-core libcurl4-openssl-dev libssl-dev libzmq3-dev libssl-dev libsasl2-dev
RUN apt-get install -y libssl-dev libffi-dev libgsl-dev
RUN apt-get install -y libv8-3.14-dev libprotobuf-dev libgdal1-dev libproj-dev

ADD requirements.txt /tmp/python/
RUN pip3 install --no-cache-dir -r /tmp/python/requirements.txt
RUN . /py27/bin/activate; pip install --no-cache-dir -r /tmp/python/requirements.txt

RUN apt-get -y update
RUN apt-get -y install python3-tk python-tk
RUN apt-get -y install vim tmux git

RUN python3 -m spacy download en
RUN . /py27/bin/activate; python -m spacy download en

COPY install-packages.r /tmp/R/
RUN Rscript /tmp/R/install-packages.r

COPY lab/jupyterlab-theme-light-extension/variables.css /usr/local/lib/python3.5/dist-packages/jupyterlab/themes/jupyterlab-theme-light-extension/
COPY lab/jupyterlab-theme-light-extension/roboto-mono.css /usr/local/lib/python3.5/dist-packages/jupyterlab/themes/jupyterlab-theme-light-extension/

COPY lab/jupyterlab-theme-dark-extension/variables.css /usr/local/lib/python3.5/dist-packages/jupyterlab/themes/jupyterlab-theme-dark-extension/
COPY lab/jupyterlab-theme-dark-extension/roboto-mono.css /usr/local/lib/python3.5/dist-packages/jupyterlab/themes/jupyterlab-theme-dark-extension/

COPY dotfiles/.* /tmp/dotfiles/ 

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/
