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
ENV WIDTH=
ENV HEIGHT=
ADD ./app /app
WORKDIR /app
CMD /bin/ash

ENTRYPOINT python pixelsort --log -s chroma -i ${WIDTH} --use-tiles --tile-x ${WIDTH} --tile-y ${HEIGHT} /source.png -o /output/output.png
#ENTRYPOINT python pixelsort --log -s hue -i ${WIDTH} --use-tiles --tile-x ${WIDTH} --tile-y ${HEIGHT} /source.png -o /output/output.png
#ENTRYPOINT python pixelsort --log -s intensity -i ${WIDTH} --use-tiles --tile-x ${WIDTH} --tile-y ${HEIGHT} /source.png -o /output/output.png
#ENTRYPOINT python pixelsort --log -s lightness -i ${WIDTH} --use-tiles --tile-x ${WIDTH} --tile-y ${HEIGHT} /source.png -o /output/output.png
#ENTRYPOINT python pixelsort --log -s luma -i ${WIDTH} --use-tiles --tile-x ${WIDTH} --tile-y ${HEIGHT} /source.png -o /output/output.png
#ENTRYPOINT python pixelsort --log -s saturation -i ${WIDTH} --use-tiles --tile-x ${WIDTH} --tile-y ${HEIGHT} /source.png -o /output/output.png
#ENTRYPOINT python pixelsort --log -s value -i ${WIDTH} --use-tiles --tile-x ${WIDTH} --tile-y ${HEIGHT} /source.png -o /output/output.png