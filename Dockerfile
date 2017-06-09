FROM openjdk

ENV GITPITCH_VERSION=1.1 \
    PLAY_CRYPTO_SECRET=Ch@ng3M3

COPY target/universal/server-${GITPITCH_VERSION}.zip /
COPY docker/config/production.conf /config/production.conf

RUN unzip server-${GITPITCH_VERSION}.zip -d /srv \
  && mv srv/server-${GITPITCH_VERSION} srv/gitpitch

ENTRYPOINT srv/gitpitch/bin/server -Dconfig.file=/config/production.conf -Dpidfile.path=/dev/null