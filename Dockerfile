FROM openjdk

ENV GITPITCH_VERSION=1.1 \
    DECKTAPE_VERSION=1.0.0 \
    PLAY_CRYPTO_SECRET=Ch@ng3M3 \
    GITHUB_API_TOKEN=your-GitHub-api-auth-token

COPY target/universal/server-${GITPITCH_VERSION}.zip /
COPY docker/config/production.conf /config/production.conf

RUN unzip server-${GITPITCH_VERSION}.zip -d /srv \
  && mv srv/server-${GITPITCH_VERSION} srv/gitpitch \
  && echo "downloading decktape ${DECKTAPE_VERSION}" \
  && curl -Ls https://github.com/astefanutti/decktape/archive/v${DECKTAPE_VERSION}.tar.gz | tar -xz --exclude phantomjs -C /srv/ \
  && mv /srv/decktape-1.0.0 /srv/decktape \
  && mkdir /srv/decktape/bin \
  && echo "downloading phantomjs for decktape ${DECKTAPE_VERSION}" \
  && curl -Ls https://github.com/astefanutti/decktape/releases/download/v${DECKTAPE_VERSION}/phantomjs-linux-x86-64 -o /srv/decktape/bin/phantomjs \
  && chmod a+x /srv/decktape/bin/phantomjs

ENTRYPOINT srv/gitpitch/bin/server \
  -Dconfig.file=/config/production.conf \
  -Dpidfile.path=/dev/null \
  -Dgitpitch.decktape.home=/srv/decktape/ \
  -Dgithub.api.token=${GITHUB_API_TOKEN}