FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gfortran \
    git \
    liblapack-dev \
    pkgconf \
    python3 \
    python3-pip

RUN pip install matplotlib jupyter
WORKDIR ./fastest-lap


COPY ./ld.fastest-lap.conf /etc/ld.so.conf.d



COPY . .

WORKDIR ./build
RUN cmake .. -DPYTHON_API_ABSOLUTE_PATH=off
RUN make

RUN cp ../examples/python/fastest_lap.py /lib/python3/dist-packages

WORKDIR /projects
EXPOSE 8888

RUN ldconfig

CMD jupyter notebook --allow-root --ip=0.0.0.0
