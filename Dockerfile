FROM ubuntu:20.04

LABEL maintainer="JamesClonk <jamesclonk@jamesclonk.ch>"

ARG package_args='--allow-downgrades --allow-remove-essential --allow-change-held-packages --no-install-recommends'
RUN echo "debconf debconf/frontend select noninteractive" | debconf-set-selections && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y $package_args update && \
  apt-get -y $package_args dist-upgrade && \
  apt-get -y $package_args install curl ca-certificates bash && \
  apt-get clean && \
  find /usr/share/doc/*/* ! -name copyright | xargs rm -rf && \
  rm -rf \
    /usr/share/man/* /usr/share/info/* \
    /var/lib/apt/lists/* /tmp/*

RUN curl -fSL "https://github.com/google/go-containerregistry/releases/download/v0.1.1/go-containerregistry_Linux_x86_64.tar.gz" -o "go-containerregistry_Linux_x86_64.tar.gz" \
  && tar -xvzf go-containerregistry_Linux_x86_64.tar.gz crane \
  && mv crane "/usr/local/bin/crane" \
  && rm -f go-containerregistry_Linux_x86_64.tar.gz \
  && chmod a+x "/usr/local/bin/crane"

RUN useradd -u 2000 -mU -s /bin/bash vcap && \
  mkdir /home/vcap/app && \
  chown vcap:vcap /home/vcap/app && \
  ln -s /home/vcap/app /app
USER vcap

WORKDIR /app
COPY pull.sh ./
COPY images.dat ./

CMD ["/app/pull.sh"]
