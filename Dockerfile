# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.18

ENV HOME /home/tester

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update

# install some other essential packages for building bitcoin
RUN apt-get install --yes \
  autoconf \ 
  autotools-dev \ 
	bsdmainutils \ 
	build-essential \ 
	gcc \ 
	git \ 
	libboost-all-dev \ 
	libssl-dev \ 
  libevent-dev \
	libtool \ 
  make \
	pkg-config \ 
	sudo

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# change root password, should still be able to change back to root
RUN echo 'root:abc123' |chpasswd

# create a non-root user
RUN useradd -d /home/tester -m -s /bin/bash tester && echo "tester:tester" | chpasswd && adduser tester sudo

# download and extract berkeley db 4.8 for wallets
# Bitcoin needs bdb for building properly
WORKDIR /home/tester
ADD http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz /home/tester

# Copy files needed: Makefile, configs
COPY ./hometester/ /home/tester/

# make tester user own the testnet
RUN chown -R tester:tester /home/tester

# run following commands from user's home directory
# use the tester user when running the image
USER tester

# This bitcoin/ will be connected to host bitcoin/
RUN mkdir -p /home/tester/bitcoin

# Build berkeley db 4.8
WORKDIR /home/tester/db-4.8.30.NC/build_unix
RUN mkdir -p /home/tester/db4
RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/home/tester/db4
RUN make install
WORKDIR /home/tester
RUN rm -rf db-4.8.30.NC
RUN rm -rf db-4.8.30.NC.tar.gz

# run commands from inside the testnet-box directory
WORKDIR /home/tester/testnet

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/bash"]
