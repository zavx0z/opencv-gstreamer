FROM zavx0z/python3:latest
ARG DEBIAN_FRONTEND=noninteractive
ENV XDG_RUNTIME_DIR=/home/tmp
#install gstreamer1.0
RUN \
    apt-get update && apt-get upgrade -y && apt-get install -y \
    gstreamer1.0-libav \
    gstreamer1.0-nice \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-pulseaudio \
    gstreamer1.0-tools \
    ubuntu-restricted-extras \
    # install lib, dev package
    libgtk2.0-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    # Install requirements for make
    git \
    build-essential \
    cmake && \
    pip3 install numpy && \
    # Clone and prepare to make opencv
    git clone https://github.com/opencv/opencv.git && \
    mkdir opencv/build && \
    cd opencv/build && \
    # Configure, Building and install
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D PYTHON_EXECUTABLE=$(which python3) \
    -D BUILD_opencv_python2=OFF \
    -D CMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
    -D PYTHON3_EXECUTABLE=$(which python3) \
    -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
    -D WITH_GSTREAMER=ON \
    -D BUILD_EXAMPLES=ON .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    # CLEAR
    apt-get autoremove -y && \
    cd / && rm -r opencv
