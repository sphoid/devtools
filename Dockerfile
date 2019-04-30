FROM ubuntu:18.04

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV DEBIAN_FRONTEND=noninteractive

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y curl supervisor git \
    && apt-get -y autoclean

# NODE
    
# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.5.0

RUN mkdir $NVM_DIR

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# PYTHON
RUN apt-get install -y python3-pip python-pip

# PHP
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install -y php-cli
RUN curl https://phar.phpunit.de/phpunit.phar --output /usr/local/bin/phpunit.phar \
    && chmod +x /usr/local/bin/phpunit.phar

