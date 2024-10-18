
FROM debian:bullseye

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y nginx openssl \
    && apt-get install -y vim \
    && apt-get install -y curl

RUN mkdir /etc/nginx/ssl

RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
        -out /etc/nginx/ssl/certificate.pem \
        -keyout /etc/nginx/ssl/certificate.key\
        -subj "/C=Mo/ST=Benguerir/L=Benguerir/O=1337/OU=ylamkhan/CN=ylamkhan/"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

CMD [ "nginx", "-g", "daemon off;" ]