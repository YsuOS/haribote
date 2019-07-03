FROM debian

RUN apt update
RUN apt install -y nasm mtools make gcc

WORKDIR /home/
CMD make
