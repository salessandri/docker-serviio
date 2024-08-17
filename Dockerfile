FROM alpine:3.20.2

ARG IMAGE_VERSION=latest
ARG BUILD_DATE
ARG GIT_SHA
ARG FFMPEG_VERSION=5.1.6
ARG SERVIIO_VERSION=2.4

LABEL \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.authors="Santiago Alessandri <santiago@salessandri.name>" \
    org.opencontainers.image.url="https://github.com/salessandri/docker-serviio" \
    org.opencontainers.image.documentation="https://github.com/salessandri/docker-serviio/README.md" \
    org.opencontainers.image.source="https://github.com/salessandri/docker-serviio" \
    org.opencontainers.image.version=$IMAGE_VERSION \
    org.opencontainers.image.revision=$GIT_SHA \
    org.opencontainers.image.title="Serviio Media Streaming Server" \
    org.opencontainers.image.description="Containerized Serviio Media Streaming Server"

RUN apk update && apk upgrade && \
    apk add --no-cache --update \
        alsa-lib \
        bzip2 \
        expat \
        fdk-aac \
        lame \
        libbz2 \
        libdrm \
        libffi \
        libjpeg-turbo \
        libtheora \
        libogg \
        libpciaccess \
        librtmp \
        libstdc++ \
        libtasn1 \
        libva \
        libvorbis \
        libvpx \
        mesa-gl \
        mesa-glapi \
        musl \
        opus \
        openjdk8-jre \
        openssl \
        p11-kit \
        sdl2 \
        x264-libs \
        x264 \
        x265 \
        libass-dev \
        gnutls-dev \
        libwebp-dev \
        lame-dev \
        v4l-utils-libs \
        xvidcore && \
    apk add --no-cache --update --virtual=.build-dependencies \
        alsa-lib-dev \
        bzip2-dev \
        coreutils \
        curl \
        fdk-aac-dev \
        freetype-dev \
        g++ \
        gcc \
        git \
        imlib2-dev \
        lcms2-dev \
        libgcc \
        libjpeg-turbo-dev \
        libtheora-dev \
        libogg-dev \
        libva-dev \
        libvorbis-dev \
        libvpx-dev \
        libx11 \
        libxau \
        libxcb \
        libxcb-dev \
        libxdamage \
        libxdmcp \
        libxext \
        libxfixes \
        libxfixes-dev \
        libxshmfence \
        libxxf86vm \
        make \
        cmake \
        musl-dev \
        nasm \
        nettle \
        opus-dev \
        openssl-dev \
        pkgconf \
        pkgconf-dev \
        rtmpdump-dev \
        sdl2-dev \
        tar \
        ttf-dejavu \
        v4l-utils-dev \
        x264-dev \
        x265-dev \
        xvidcore-dev \
        yasm-dev \
        zlib-dev && \
    mkdir build && cd build && \
    curl -s https://ffmpeg.org//releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | tar xfj - && \
    cd ffmpeg-${FFMPEG_VERSION} && \
    ./configure \
        --disable-doc \
        --disable-debug \
        --disable-shared \
        --enable-avfilter \
        --enable-swresample \
        --enable-gnutls \
        --enable-gpl \
        --enable-libass \
        --enable-libfdk-aac \
        --enable-libfreetype \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-librtmp \
        --enable-libtheora \
        --enable-libv4l2 \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libwebp \
        --enable-libx264 \
        --enable-libx265 \
        --enable-libxcb \
        --enable-libxvid \
        --enable-nonfree \
        --enable-pic \
        --enable-pthreads \
        --enable-postproc \
        --enable-static \
        --enable-small \
        --enable-version3 \
        --enable-vaapi \
        --extra-libs="-lpthread -lm" \
        --prefix=/usr && \
    make -j && \
    make install && \
    cd ../../ && rm -rf build && \
    curl -s https://download.serviio.org/releases/serviio-${SERVIIO_VERSION}-linux.tar.gz | tar xvfz - && \
    mkdir -p /opt/serviio && \
    mv ./serviio-${SERVIIO_VERSION}/* /opt/serviio && \
    rmdir /serviio-${SERVIIO_VERSION}/ && \
    apk del --purge .build-dependencies && \
    rm -rf /var/cache/apk/*

EXPOSE 1900/udp \
    8895/tcp \
    23423/tcp \
    23523/tcp \
    23424/tcp \
    23524/tcp

ENTRYPOINT [ "/opt/serviio/bin/serviio.sh" ]
