# Inspired by https://github.com/mumoshu/dcind
FROM alpine:3.20.1

ENV DOCKER_VERSION=25.0.3 \
    DOCKER_COMPOSE_VERSION=2.28.1

# Install Docker
RUN apk --no-cache add bash curl util-linux device-mapper py3-pip python3-dev libffi-dev openssl-dev gcc libc-dev make iptables
RUN curl https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar zx && \
    mv /docker/* /bin/ && \
    chmod +x /bin/docker*
# Install Docker Compose
RUN mkdir -p ~/.docker/cli-plugins && \
    curl -SL https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose && \
    chmod +x ~/.docker/cli-plugins/docker-compose && \
    echo -e '#!/bin/bash\nexec docker compose "$@"' > /usr/bin/docker-compose && \
    chmod +x /usr/bin/docker-compose

# Include functions to start/stop docker daemon
COPY docker-lib.sh /docker-lib.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
