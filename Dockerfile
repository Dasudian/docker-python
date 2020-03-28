FROM python:3.7

ENV OPENCV_VERSION="4.2.0" \
        OPENCV_CONTRIB_VERSION="4.2.0"

RUN apt update \
    && buildDeps='git build-essential cmake git pkg-config gfortran openexr libtbb2 python3-dev python3-numpy' \
    && devDeps='libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev libatlas-base-dev libtbb-dev libdc1394-22-dev' \
    && apt install -y --no-install-recommends $buildDeps \
    && apt install -y --no-install-recommends $devDeps \
    && mkdir ~/opencv_build && cd ~/opencv_build \
    && curl -sSL https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -o opencv-${OPENCV_VERSION}.zip \
    && curl -sSL https://github.com/opencv/opencv_contrib/archive/${OPENCV_CONTRIB_VERSION}.zip -o opencv_contrib-${OPENCV_CONTRIB_VERSION}.zip \
    && unzip -qq opencv-${OPENCV_VERSION}.zip && mv opencv-${OPENCV_VERSION} opencv \
    && unzip -qq opencv_contrib-${OPENCV_CONTRIB_VERSION}.zip  && mv opencv_contrib-${OPENCV_CONTRIB_VERSION} opencv_contrib \
    && cd ~/opencv_build/opencv/ \
    && mkdir build && cd build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D OPENCV_GENERATE_PKGCONFIG=ON \
      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules \
      -D BUILD_EXAMPLES=ON .. \
    && make -j$(nproc) \
    && make install \
    && apt-get purge -y --auto-remove $devDeps \
    && apt-get clean all \
    && rm -rf ~/opencv_build /var/lib/apt/lists/*
