FROM debian:buster

# set environment variables
ENV VOLTTRON_GIT_BRANCH=master
ENV VOLTTRON_USER_HOME=/home/volttron
ENV VOLTTRON_HOME=${VOLTTRON_USER_HOME}/.volttron
ENV VOLTTRON_ROOT=/code/volttron
ENV VOLTTRON_USER=volttron

# install VOLTTRON dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python-dev \
    openssl \
    libssl-dev \
    libevent-dev \
    python-pip \
    python-setuptools\
    python-wheel\
    git \
    gnupg \
    dirmngr \
    && pip install PyYAML \
    && rm -rf /var/lib/apt/lists/*

# create volttron user
RUN adduser --disabled-password --gecos "" $VOLTTRON_USER

# create directory and clone volttron into
RUN mkdir /code && chown $VOLTTRON_USER.$VOLTTRON_USER /code
USER $VOLTTRON_USER
WORKDIR /code
RUN git clone https://github.com/VOLTTRON/volttron -b ${VOLTTRON_GIT_BRANCH}

# bootstrap platform
WORKDIR /code/volttron
RUN python bootstrap.py

# start volttron environment
RUN . env/bin/activate

CMD ["/bin/bash"]