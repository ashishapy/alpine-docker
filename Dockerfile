FROM alpine:3.4

# Install packages
RUN apk update && apk add --no-cache \
		ca-certificates \
		curl \
		openssl

# To control Docker and Docker Compose versions installed
ARG DOCKER_ENGINE=1.12.0
ARG DOCKER_COMPOSE=1.8.0
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_SHA256 3dd07f65ea4a7b4c8829f311ab0213bca9ac551b5b24706f3e79a97e22097f8b

# Install Docker Engine
RUN set -x \
	&& curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_ENGINE:-1.12.0}.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

# Install Docker Compose
RUN apk add 'py-pip' \
	&& pip install 'docker-compose==${DOCKER_COMPOSE:-1.8.0}' \
	&& docker-compose -v

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
