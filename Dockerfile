FROM alpine
MAINTAINER Michael Ruettgers <michael@ruettgers.eu>

ENV ESNIPER_VERSION 2.33.0
ENV ESNIPER_URL "http://netcologne.dl.sourceforge.net/project/esniper/esniper/2.33.0/esniper-2-33-0.tgz"

RUN apk add --update build-base curl-dev bash && \
  rm -rf /var/cache/apk/*

RUN cd /tmp/ && \
  BUILDDIR=/tmp/esniper-${ESNIPER_VERSION//./-} && \
  echo "Fetching ${ESNIPER_URL}..." && \
  wget -q "${ESNIPER_URL}" -O- | tar zxf - && \
  echo "Changing to build dir ${BUILDDIR}..." && \
  cd ${BUILDDIR} && \
  ./configure && \
  make && \
  make install && \
  cd /tmp && \
  rm -rf ${BUILDDIR} 

RUN ([ -d /var/lib/esniper ] || mkdir -p /var/lib/esniper) && \
    ([ -d /var/lib/esniper/logs ] || mkdir -p /var/lib/esniper/logs) && \
    addgroup esniper && \
    adduser -D -G esniper -h /var/lib/esniper -u 1000 esniper && \
    chown -R esniper:esniper /var/lib/esniper

COPY ./docker/ /docker/
WORKDIR /var/lib/esniper
USER esniper
ENTRYPOINT ["/docker/entrypoint.sh"]