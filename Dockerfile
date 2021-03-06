FROM alpine:latest

ADD ./app /app
WORKDIR /app
VOLUME /output
RUN apk update \
&& apk upgrade \
&& apk add --no-cache \
    python3 \
    libjpeg \
&& apk add --no-cache --virtual build-deps \
    build-base \
    gcc \
    py3-pip \
    jpeg-dev\
    python3-dev \
    zlib-dev \
&& ln -sf python3 /usr/bin/python \
&& pip install \
    wheel \
    typing \
&& LIBRARY_PATH=/lib:/usr/lib pip install \
    pillow \
&& apk del build-deps \
&& rm -rf /var/cache/apk/*
ENTRYPOINT python /app/pixelsort --log -i 65000 /source.png -o /output/output.png
