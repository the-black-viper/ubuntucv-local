FROM ubuntu:18.04 AS test

LABEL maintainer="Joshua Javier"

ENV RUSTUP_HOME=/usr/local/rustup \
  CARGO_HOME=/usr/local/cargo \
  PATH=/usr/local/cargo/bin:$PATH \
  RUST_VERSION=1.33.0 \
  USER=root

RUN apt-get update

RUN mkdir /opencv /root/.ssh /opt/opencv-4.0.1

##Install OPENCV Dependencies
#Base packages
COPY build-essential/* /var/cache/apt/archives/
RUN apt-get install -y build-essential;
COPY cmake/* /var/cache/apt/archives/
RUN apt-get install -y cmake;
COPY git/* /var/cache/apt/archives/
RUN apt-get install -y git;
COPY libgtk2.0-dev/* /var/cache/apt/archives/
RUN apt-get install -y libgtk2.0-dev;

COPY libavcodec-dev/* /var/cache/apt/archives/
RUN apt-get install -y libavcodec-dev;
COPY libavformat-dev/* /var/cache/apt/archives/
RUN apt-get install -y libavformat-dev;
COPY libswscale-dev/* /var/cache/apt/archives/
RUN apt-get install -y libswscale-dev;

#Python libraries
COPY python-dev/* /var/cache/apt/archives/
RUN apt-get install -y python-dev;
COPY python3-dev/* /var/cache/apt/archives/
RUN apt-get install -y python3-dev;
COPY python-numpy/* /var/cache/apt/archives/
RUN apt-get install -y python-numpy;
COPY python3-numpy/* /var/cache/apt/archives/
RUN apt-get install -y python3-numpy;

#Image libraries
COPY libtbb2/* /var/cache/apt/archives/
RUN apt-get install -y libtbb2;
COPY libtbb-dev/* /var/cache/apt/archives/
RUN apt-get install -y libtbb-dev;

COPY libjpeg-dev/* /var/cache/apt/archives/
RUN apt-get install -y libjpeg-dev;
COPY libtiff-dev/* /var/cache/apt/archives/
RUN apt-get install -y libtiff-dev;

COPY unzip/* /var/cache/apt/archives/
RUN apt-get install -y unzip;


