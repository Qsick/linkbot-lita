FROM litaio/lita

RUN /usr/bin/apt-get update && \
    /usr/bin/apt-get install -y git && \
    /usr/bin/apt-get clean && \
    /bin/rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    /usr/local/bin/gem install bundler
