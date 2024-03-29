FROM alpine:3.19.0 as build

ARG FFMPEG_VERSION=6.1.1
ARG X264_BRANCH=stable

ARG PREFIX=/usr/local
ARG LD_LIBRARY_PATH=/usr/local/lib
ARG MAKEFLAGS="-j$(nproc)"

# Install ffmpeg build dependencies
RUN apk add --update \
    bash \
    build-base \
    coreutils \
    freetype-dev \
    gcc \
    nasm \
    lame-dev \
    libogg-dev \
    libass \
    libass-dev \
    libvpx-dev \
    libvorbis-dev \
    libwebp-dev \
    libtheora-dev \
    opus-dev \
    openssl \
    openssl-dev \
    patch \
    pkgconf \
    pkgconfig \
    rtmpdump-dev \
    wget \
    # x264-dev \
    x265-dev \
    yasm

# Get x264
RUN cd /tmp && \
    wget https://code.videolan.org/videolan/x264/-/archive/${X264_BRANCH}/x264-${X264_BRANCH}.tar.bz2 && \
    tar xf x264-${X264_BRANCH}.tar.bz2 && rm x264-${X264_BRANCH}.tar.bz2
# Patch and build x264
ADD add_eos_eob.diff /tmp/add_eos_eob.diff
RUN cd /tmp/x264-${X264_BRANCH} && \
    patch -p1 < /tmp/add_eos_eob.diff && \
    ./configure --prefix="${PREFIX}" --enable-pic --enable-shared && \
    make && make install && make clean

# Get ffmpeg
RUN cd /tmp && \
    wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    tar xf ffmpeg-${FFMPEG_VERSION}.tar.gz && rm ffmpeg-${FFMPEG_VERSION}.tar.gz

# Build
RUN cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
    ./configure \
    --enable-version3 \
    --enable-gpl \
    --enable-nonfree \
    --enable-small \
    --enable-libmp3lame \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libvpx \
    --enable-libtheora \
    --enable-libvorbis \
    --enable-libopus \
    --enable-libass \
    --enable-libwebp \
    --enable-librtmp \
    --enable-postproc \
    --enable-libfreetype \
    --enable-openssl \
    --disable-debug \
    --disable-doc \
    --disable-ffplay \
    --extra-cflags="-I${PREFIX}/include" \
    --extra-ldflags="-L${PREFIX}/lib" \
    --extra-libs="-lpthread -lm" \
    --prefix="${PREFIX}" && \
    make && make install && make distclean

# Cleanup.
RUN rm -rf /var/cache/apk/* /tmp/*
ENTRYPOINT ["/usr/local/bin/ffmpeg"]
