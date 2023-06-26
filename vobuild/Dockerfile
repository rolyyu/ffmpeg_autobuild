FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

COPY ./install /vooptimizer/

# get and install dependencies
RUN apt-get update -qq && apt-get -y install --no-install-recommends \
        libfdk-aac-dev \
        libnuma-dev

# setup environment
ENV PATH=$PATH:/vooptimizer/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/vooptimizer/lib

