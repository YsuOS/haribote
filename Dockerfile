FROM ubuntu

RUN apt update
RUN apt install nasm mtools make

WORKDIR /home/
CMD make
