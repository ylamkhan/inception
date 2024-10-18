
FROM debian:bullseye

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y mariadb-server systemctl vim

COPY tools/init.sh /tmp/init.sh

CMD [ "bash", "/tmp/init.sh" ]
