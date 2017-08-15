FROM alpine
MAINTAINER Michael Ruettgers <michael@ruettgers.eu>

ENV ESNIPER_VERSION 2.33.0

RUN apk add --update build-base curl-dev bash && \
  rm -rf /var/cache/apk/*

RUN cd /tmp/ && \
  wget -q http://netcologne.dl.sourceforge.net/project/esniper/esniper/${ESNIPER_VERSION}/esniper-${ESNIPER_VERSION//./-}.tgz -O -|tar zxvf - && \
  BUILDDIR=/tmp/esniper-${ESNIPER_VERSION//./-} && \
  cd ${BUILDDIR} && \
  ./configure && \
  make && \
  make install && \
  cd /tmp && \
  rm -rf ${BUILDDIR} 

RUN ([ -d /var/lib/esniper ] || mkdir -p /var/lib/esniper) && \
    addgroup esniper && \
    adduser -D -G esniper -h /var/lib/esniper -u 1000 esniper

COPY ./docker/ /docker/
WORKDIR /var/lib/esniper
USER esniper
ENTRYPOINT ["/docker/entrypoint.sh"]