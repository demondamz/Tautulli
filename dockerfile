FROM ubuntu:latest

# Set Container Variables 
SHELL ["/bin/bash", "-c"]
LABEL maintainer="Demondamz"
ENV TZ=UTC

# Install core packages and updates
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install python3 python3-venv python3-all-dev  python3-pip git-core -y 

# Install Tautulli into container 
COPY . /opt/Tautulli
RUN cd /opt/Tautulli &&  \
    python3 -m venv /opt/Tautulli && \
    source bin/activate && \
    python3 -m pip install --upgrade pip setuptools pip-tools && \
    pip install -r requirements.txt

# Create Config Folder
RUN \
  mkdir /config /logs /scripts 

# Map Volumes   
VOLUME [ "/etc/localtime" ]
VOLUME [ "/logs" ]
VOLUME [ "/config" ]
VOLUME [ "/scripts" ]

WORKDIR /opt/Tautulli

CMD ["/opt/Tautulli/bin/python3","Tautulli.py", "--datadir", "/config" ]

EXPOSE 8181
HEALTHCHECK --start-period=90s CMD curl -ILfSs http://localhost:8181/status > /dev/null || curl -ILfkSs https://localhost:8181/status > /dev/null || exit 1
