FROM alpine:latest

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
&& pip install \
    typing \
&& LIBRARY_PATH=/lib:/usr/lib pip install \
    pillow \
&& apk del build-deps \
&& rm -rf /var/cache/apk/*
ENV WIDTH=20 HEIGHT=20
ADD ./app /app
WORKDIR /app
CMD /bin/ash
#ENTRYPOINT python pixelsort --image-threshold 0 -i ${WIDTH} --use-tiles --tile-x ${WIDTH} --tile-y ${HEIGHT} /source.png -o /output/output.png --log
ENTRYPOINT python pixelsort --image-threshold 0 -i ${WIDTH} /source.png -o /output/output.png --log
