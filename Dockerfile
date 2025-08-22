FROM alpine:3

LABEL maintainer="ugeek. ugeekpodcast@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/ugeek/docker-webdav"
LABEL org.opencontainers.image.description="WebDAV server based on Nginx"

ARG UID=${UID:-1000}
ARG GID=${GID:-1000}

RUN apk add --no-cache \
    nginx \
    nginx-mod-http-dav-ext \
    nginx-mod-http-headers-more \
    apache2-utils \
    shadow && \
    mkdir -p /run/nginx && \
    rm -rf /var/cache/apk/*

RUN usermod -u $UID nginx && \
    groupmod -g $GID nginx && \
    chown -R nginx:nginx /var/lib/nginx /var/log/nginx /run/nginx

VOLUME /media
EXPOSE 8080

COPY nginx.conf /etc/nginx/nginx.conf
COPY webdav.conf /etc/nginx/http.d/default.conf
RUN rm -f /etc/nginx/http.d/default.conf.example 2>/dev/null || true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/bin/sh", "-c", "/entrypoint.sh && exec nginx -g 'daemon off;'"]
