FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Minsk
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y make git zlib1g-dev libssl-dev gperf php cmake clang-10 libc++-dev libc++abi-dev
RUN git clone https://github.com/tdlib/td.git

WORKDIR /td
RUN rm -rf build
RUN mkdir build

WORKDIR /td/build

RUN echo "1" > /usr/local/test.txt
RUN export CXXFLAGS="-stdlib=libc++"

# build optimization It can significantly reduce binary size and increase performance, but sometimes it can lead to build failures.
# RUN CC=/usr/bin/clang-10 CXX=/usr/bin/clang++-10 cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -DTD_ENABLE_LTO=ON -DCMAKE_AR=/usr/bin/llvm-ar-10 -DCMAKE_NM=/usr/bin/llvm-nm-10 -DCMAKE_OBJDUMP=/usr/bin/llvm-objdump-10 -DCMAKE_RANLIB=/usr/bin/llvm-ranlib-10 ..

# regular build
RUN CC=/usr/bin/clang-10 CXX=/usr/bin/clang++-10 cmake -DTD_ENABLE_DOTNET=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..
RUN cmake --build . --target install

WORKDIR /usr/local
RUN ls -l
