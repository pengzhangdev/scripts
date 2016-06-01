FROM ubuntu:14.04
MAINTAINER Carl Tao <carltao@gmail.com>

RUN apt-get update && apt-get -y upgrade


RUN apt-get -y install build-essential lib32readline6-dev g++-multilib u-boot-tools gettext libswitch-perl bc openjdk-7-jdk || echo Ignore colord error

RUN apt-get -y autoremove && apt-get -y install libelfg0 libglib2.0-bin libglib2.0-dev libpcre3-dev libpcrecpp0 pkg-config

RUN apt-get -y install autoconf automake autotools-dev libauthen-sasl-perl libencode-locale-perl libfile-listing-perl libfont-afm-perl libhtml-form-perl libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libio-html-perl libio-socket-inet6-perl libio-socket-ssl-perl liblwp-mediatypes-perl liblwp-protocol-https-perl libmailtools-perl libnet-http-perl libnet-smtp-ssl-perl libnet-ssleay-perl libsocket6-perl liburi-perl libwww-perl libwww-robotrules-perl libxml-parser-perl 


RUN apt-get -y install gcc-multilib g++-multilib && apt-get -y install zlib1g-dev ccache wget git-core gnupg flex bison gperf  zip curl libc6-dev lib32ncurses5-dev x11proto-core-dev libx11-dev lib32readline-gplv2-dev lib32z-dev   libgl1-mesa-dev mingw32 tofrodos python-markdown   libxml2-utils xsltproc python-networkx make

RUN apt-get -y install intltool libltdl-dev

RUN useradd --create-home werther
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["bash"]
