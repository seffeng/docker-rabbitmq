FROM seffeng/alpine:3.16

LABEL author="zxf <seffeng@live.com>"

ARG BASE_DIR="/opt/websrv"

ENV RABBITMQ_NAME=rabbitmq-server-generic-unix-\
 RABBITMQ_SERVER=rabbitmq_server-\
 RABBITMQ_VERSION=3.10.18\
 CONFIG_DIR="${BASE_DIR}/config/rabbitmq"\
 INSTALL_DIR="${BASE_DIR}/program/rabbitmq"\
 BASE_PACKAGE="xz"\
 EXTEND="erlang"

ENV RABBITMQ_URL="https://github.com/rabbitmq/rabbitmq-server/releases/download/v${RABBITMQ_VERSION}/${RABBITMQ_NAME}${RABBITMQ_VERSION}.tar.xz"

WORKDIR /tmp
COPY    conf ./conf

RUN apk add --update --no-cache ${BASE_PACKAGE} ${EXTEND} &&\
 wget ${RABBITMQ_URL} &&\
 xz -d ${RABBITMQ_NAME}${RABBITMQ_VERSION}.tar.xz &&\
 tar -xf ${RABBITMQ_NAME}${RABBITMQ_VERSION}.tar &&\
 mkdir -p ${BASE_DIR}/logs ${BASE_DIR}/tmp ${CONFIG_DIR} ${INSTALL_DIR} &&\
 rm -rf ${INSTALL_DIR} && mv ${RABBITMQ_SERVER}${RABBITMQ_VERSION} ${INSTALL_DIR} &&\
 chmod 777 ${BASE_DIR}/tmp &&\
 chmod 777 ${BASE_DIR}/logs &&\
 cp -Rf /tmp/conf/* ${CONFIG_DIR} &&\
 ln -s ${INSTALL_DIR}/sbin/rabbitmq-defaults /usr/bin/rabbitmq-defaults &&\
 ln -s ${INSTALL_DIR}/sbin/rabbitmq-diagnostics /usr/bin/rabbitmq-diagnostics &&\
 ln -s ${INSTALL_DIR}/sbin/rabbitmq-env /usr/bin/rabbitmq-env &&\
 ln -s ${INSTALL_DIR}/sbin/rabbitmq-plugins /usr/bin/rabbitmq-plugins &&\
 ln -s ${INSTALL_DIR}/sbin/rabbitmq-queues /usr/bin/rabbitmq-queues &&\
 ln -s ${INSTALL_DIR}/sbin/rabbitmq-server /usr/bin/rabbitmq-server &&\
 ln -s ${INSTALL_DIR}/sbin/rabbitmq-upgrade /usr/bin/rabbitmq-upgrade &&\
 ln -s ${INSTALL_DIR}/sbin/rabbitmqctl /usr/bin/rabbitmqctl &&\
 rm -rf ${INSTALL_DIR}/etc/rabbitmq &&\
 ln -s ${CONFIG_DIR} ${INSTALL_DIR}/etc/rabbitmq &&\
 rabbitmq-plugins enable --offline rabbitmq_management &&\
 apk del ${BASE_PACKAGE} &&\
 rm -rf /var/cache/apk/* &&\
 rm -rf /tmp/*

VOLUME ["${BASE_DIR}/data/rabbitmq", "${BASE_DIR}/tmp", "${BASE_DIR}/logs"]

EXPOSE 4369 5671 5672 15691 15692 25672
EXPOSE 15671 15672

CMD ["rabbitmq-server"]