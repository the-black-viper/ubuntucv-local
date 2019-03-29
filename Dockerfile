FROM ubuntu:18.04 AS test

LABEL maintainer="Joshua Javier"

RUN sed -i 's/archive.ubuntu.com/mirror.pregi.net/' /etc/apt/sources.list;
RUN apt-get update
RUN mkdir /opencv /root/.ssh 

#Install OPENCV Dependencies
# Base packages
COPY opencv_depends/build-essential/* /var/cache/apt/archives/
RUN apt-get install -y build-essential=12.4ubuntu1;
COPY opencv_depends/cmake/* /var/cache/apt/archives/
RUN apt-get install -y cmake=3.10.2-1ubuntu2;
COPY opencv_depends/git/* /var/cache/apt/archives/
RUN apt-get install -y git=1:2.17.1-1ubuntu0.4;
COPY opencv_depends/libgtk2.0-dev/* /var/cache/apt/archives/
RUN apt-get install -y libgtk2.0-dev=2.24.32-1ubuntu1;

COPY opencv_depends/libavcodec-dev/* /var/cache/apt/archives/
RUN apt-get install -y libavcodec-dev=7:3.4.4-0ubuntu0.18.04.1;
COPY opencv_depends/libavformat-dev/* /var/cache/apt/archives/
RUN apt-get install -y libavformat-dev=7:3.4.4-0ubuntu0.18.04.1;
COPY opencv_depends/libswscale-dev/* /var/cache/apt/archives/
RUN apt-get install -y libswscale-dev=7:3.4.4-0ubuntu0.18.04.1;

#Python libraries
COPY opencv_depends/python-dev/* /var/cache/apt/archives/
RUN apt-get install -y python-dev=2.7.15~rc1-1;
COPY opencv_depends/python3-dev/* /var/cache/apt/archives/
RUN apt-get install -y python3-dev=3.6.7-1~18.04;
COPY opencv_depends/python-numpy/* /var/cache/apt/archives/
RUN apt-get install -y python-numpy=1:1.13.3-2ubuntu1;
COPY opencv_depends/python3-numpy/* /var/cache/apt/archives/
RUN apt-get install -y python3-numpy=1:1.13.3-2ubuntu1;

COPY opencv_depends/libtbb2/* /var/cache/apt/archives/
RUN apt-get install -y libtbb2=2017~U7-8;
COPY opencv_depends/libtbb-dev/* /var/cache/apt/archives/
RUN apt-get install -y libtbb-dev=2017~U7-8;

#Image libraries
COPY opencv_depends/libjpeg-dev/* /var/cache/apt/archives/
RUN apt-get install -y libjpeg-dev=8c-2ubuntu8;
COPY opencv_depends/libtiff-dev/* /var/cache/apt/archives/
RUN apt-get install -y libtiff-dev=4.0.9-5ubuntu0.2;

COPY opencv_depends/unzip/* /var/cache/apt/archives/
RUN apt-get install -y unzip=6.0-21ubuntu1;

COPY opencv_depends/wget/* /var/cache/apt/archives/
RUN apt-get install -y wget=1.19.4-1ubuntu2.1;

#Checkinstall
COPY opencv_depends/checkinstall/* /var/cache/apt/archives/
RUN apt-get install -y checkinstall=1.6.2-4ubuntu2;


ENV OPENCV_VERSION='4.0.1'

RUN cd /opt && \
  wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
  unzip ${OPENCV_VERSION}.zip && \
  rm -rf ${OPENCV_VERSION}.zip

RUN mkdir -p /opt/opencv-${OPENCV_VERSION}/build && \
  cd /opt/opencv-${OPENCV_VERSION}/build && \
  cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D BUILD_DOCS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_opencv_apps=OFF \
    -D BUILD_opencv_python2=ON \
    -D BUILD_opencv_python3=ON \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_SHARED_LIBS=ON \
    -D OPENCV_GENERATE_PKGCONFIG=YES \
    -D BUILD_TESTS=OFF \
    -D ENABLE_PRECOMPILED_HEADERS=OFF\
    -D FORCE_VTK=OFF \
    -D WITH_FFMPEG=OFF \
    -D WITH_GDAL=OFF \ 
    -D WITH_IPP=OFF \
    -D WITH_OPENEXR=OFF \
    -D WITH_OPENGL=OFF \ 
    -D WITH_QT=OFF\
    -D WITH_TBB=OFF \ 
    -D WITH_XINE=OFF \ 
    -D BUILD_JPEG=ON  \
    -D BUILD_TIFF=ON \
    -D BUILD_PNG=ON \
  .. && \
  make -j4 && \
  make install && \
  rm -rf /opt/opencv-${OPENCV_VERSION}

  RUN ldconfig -v