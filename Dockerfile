FROM jupyter/minimal-notebook:65761486d5d3

MAINTAINER Pedro M. Gordaliza <pedro.macias.gordaliza@gmail.com>
##from Jean-Remi King Dockerfile

# Install core debian packages
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
    openssh-client \
    vim \
    curl \
    gcc \
    unzip \ 
    && apt-get clean

# Xvfb
RUN apt-get install -yq --no-install-recommends \
    xvfb \
    x11-utils \
    libx11-dev \
    qt4-default \
    && apt-get clean

ENV DISPLAY=:99


RUN apt-get install -yq --no-install-recommends pypy-dev
# Switch to notebook user
USER $NB_UID

# Upgrade the package managers
RUN pip install --upgrade pip
RUN npm i npm@latest -g

RUN wget https://downloads.python.org/pypy/pypy2.7-v7.3.4-linux64.tar.bz2
RUN tar xf pypy2.7-v7.3.4-linux64.tar.bz2

ENV PATH="/pypy2.7-v7.3.4-linux64/bin:${PATH}"
RUN pip install pypy2.7-v7.3.4-linux64.tar.bz2

RUN conda init bash

RUN conda config --set channel_priority strict

RUN conda create -yn py27-b4p python=2.7.15 pypy2.7

#COPY working_reqs_builds.txt .

RUN conda install -y -n py27-b4p --quiet mayavi=4.6.0
RUN conda install -y -n py27-b4p --quiet pydicom=1.3.0
RUN conda install -y -n py27-b4p --quiet pyqt=4.11.4
RUN conda install -y -n py27-b4p --quiet pandas=0.24.2
RUN conda install -y -n py27-b4p --quiet nibabel=2.5.1

RUN echo "source activate py27-b4p" > ~/.bashrc
ENV PATH /opt/conda/envs/py27-b4p/bin:$PATH
RUN pip install -q matplotlib==2.2.5 pyface==6.0.0 pysurfer==0.7 traitsui==6.1.0 vtk==8.1.0 apptools==4.4.0 

#WORKDIR /
####
#RUN wget https://github.com/WhitakerLab/BrainsForPublication/archive/refs/tags/v0.2.1.zip && \
#unzip v0.2.1.zip

#RUN pip install pandas seaborn 
#WORKDIR /BrainsForPublication-0.2.1
#RUN chmod +x scripts/*.py
#WORKDIR scripts


