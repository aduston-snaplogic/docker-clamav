FROM ubuntu:14.04

RUN apt-get update && apt-get install -y clamav-daemon python python-setuptools build-essential python-dev
RUN freshclam
RUN mkdir /clamav && chown clamav:clamav /clamav
COPY ./etc /clamav/etc
COPY demo-app /app
WORKDIR /app
RUN /usr/bin/python /app/setup.py install
COPY entrypoint.sh /entrypoint.sh
USER root
ENTRYPOINT ["/entrypoint.sh"]
