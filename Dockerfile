FROM alpine:3.4

RUN apk --update add bash curl openjdk7-jre
RUN mkdir -p /opt

ENV ZOOKEEPER_VERSION 3.4.8
RUN curl -sS http://mirrors.sonic.net/apache/zookeeper/current/zookeeper-${ZOOKEEPER_VERSION}.tar.gz \
  | tar -xzf - -C /opt \
  && mv /opt/zookeeper-* /opt/zookeeper \
  && chown -R root:root /opt/zookeeper
RUN addgroup zookeeper \
  && adduser -h /var/lib/zookeeper -s /sbin/nologin -G zookeeper zookeeper -S -D -H \
  && mkdir /var/lib/zookeeper \
  && chown -R zookeeper:zookeeper /var/lib/zookeeper

ADD ./src /
RUN chmod +x /usr/local/sbin/start.sh

VOLUME ["/opt/zookeeper/conf", "/var/lib/zookeeper"]
EXPOSE 2181 2888 3888
ENTRYPOINT ["/usr/local/sbin/start.sh"]
