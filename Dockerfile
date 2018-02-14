FROM ubuntu:14.04
ARG appuser=demo
ENV appuser=${appuser}
# Install needed packages. apparmor-utils may be needed to get clamd OnAccess scanning to work.
RUN apt-get update && apt-get install -y clamav-daemon \
                                         python \
                                         python-setuptools \
                                         build-essential \
                                         python-dev \
                                         && rm -rf /var/lib/apt/lists/*

# Add an app user
RUN useradd -c 'Demo app user' -m -d /home/$appuser -s /bin/bash $appuser

# Update the virus database
RUN freshclam

# Set up directories & copy config files
RUN mkdir /clamav && chown clamav:clamav /clamav

# Copy the demo app and install it
COPY demo-app /app
RUN chown -R $appuser /app
WORKDIR /app
RUN /usr/bin/python /app/setup.py install

# Copy the bootstrap script and set it as the container entrypoint
COPY entrypoint.sh /entrypoint.sh
USER root
ENTRYPOINT ["/entrypoint.sh"]

