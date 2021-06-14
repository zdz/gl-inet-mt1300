#!/bin/bash

apt update
apt upgrade -y
apt-get -y install build-essential asciidoc binutils bzip2 gawk \
	gettext git libncurses5-dev libz-dev patch python3 python2.7 \
	unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs \
	git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo \
	libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake \
	libtool autopoint device-tree-compiler g++-multilib antlr3 gperf \
	wget curl swig rsync

apt install asciidoc bash bc binutils bzip2 fastjar flex gawk gcc genisoimage \
gettext git intltool jikespg libgtk2.0-dev libncurses5-dev libssl1.0-dev make \
mercurial patch perl-modules python2.7-dev rsync ruby sdcc subversion unzip util-linux \
wget xsltproc zlib1g-dev zlib1g-dev -y	

# apt-get -qq autoremove --purge
apt-get -qq clean
ldconfig