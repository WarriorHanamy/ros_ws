FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    pkg-config \
    autoconf \
    libtool \
    wget \
    curl \
    ca-certificates \
    gnupg \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' && \
    apt-get update && apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /build

RUN git clone --depth 1 --branch 1.7.2 https://github.com/eclipse-zenoh/zenoh-c.git && \
    cd zenoh-c && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build . --config Release -j$(nproc) && \
    cmake --build . --target install && \
    cd /build && rm -rf zenoh-c

RUN git clone --depth 1 --branch 1.7.2 https://github.com/eclipse-zenoh/zenoh-cpp.git && \
    cd zenoh-cpp && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build . --config Release -j$(nproc) && \
    cmake --build . --target install && \
    cd /build && rm -rf zenoh-cpp

WORKDIR /app

COPY . /app/

RUN mkdir -p build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . --config Release -j$(nproc)

CMD ["./build/publish_vector"]
