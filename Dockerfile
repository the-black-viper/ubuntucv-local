FROM ubuntu:18.04 AS test

LABEL maintainer="Joshua Javier"

ENV RUSTUP_HOME=/usr/local/rustup \
  CARGO_HOME=/usr/local/cargo \
  PATH=/usr/local/cargo/bin:$PATH \
  RUST_VERSION=1.33.0 \
  USER=root

RUN apt-get update

RUN mkdir /opencv /root/.ssh 

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

COPY libtbb2/* /var/cache/apt/archives/
RUN apt-get install -y libtbb2;
COPY libtbb-dev/* /var/cache/apt/archives/
RUN apt-get install -y libtbb-dev;

#Image libraries
COPY libjpeg-dev/* /var/cache/apt/archives/
RUN apt-get install -y libjpeg-dev;
COPY libtiff-dev/* /var/cache/apt/archives/
RUN apt-get install -y libtiff-dev;

COPY unzip/* /var/cache/apt/archives/
RUN apt-get install -y unzip;

#Checkinstall
COPY checkinstall/* /var/cache/apt/archives/
RUN apt-get install -y checkinstall

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
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_SHARED_LIBS=ON \ 
    -D BUILD_TESTS=OFF \
    -D ENABLE_PRECOMPILED_HEADERS=OFF \
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