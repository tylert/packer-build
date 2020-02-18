# docker build \
#     --build-arg foo=bar \
#     --file Dockerfile \
#     --tag namespace/user:tag \
#     --target builder \
#     .
# docker run \
#     --interactive \
#     --rm \
#     --tty \
#     --volume ${PWD}/source:/tmp/source \
#     --volume ${PWD}/template:/tmp/template \
#     namespace/user:tag ${EXTRA_CMD_ARGS}

ARG PYTHON_IMAGE=python:3.7.5-slim-buster
FROM ${PYTHON_IMAGE} AS generator
LABEL maintainer="Tyler Tidman <tyler.tidman@draak.ca>"
WORKDIR /tmp/
RUN pip install ruamel.yaml==0.16.5
COPY script/* /tmp/
ENTRYPOINT ["bash", "generate_templates.sh"]

FROM alpine:latest AS fetcher
ARG PACKER_VERSION=1.5.0
LABEL maintainer="Tyler Tidman <tyler.tidman@draak.ca>"
WORKDIR /tmp/
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip

FROM alpine:latest AS builder
LABEL maintainer="Tyler Tidman <tyler.tidman@draak.ca>"
WORKDIR /tmp/
COPY --from=fetcher /tmp/packer /usr/local/bin
ENTRYPOINT ["packer", "version"]
