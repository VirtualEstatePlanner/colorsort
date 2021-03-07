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
ENV OUTPUTFILE=
ADD ./app /app
WORKDIR /app
CMD /bin/ash

ENTRYPOINT python pixelsort --log -s saturation /source.png -o /output/${OUTPUTFILE}.png
