# See Makefile for building and usage.

# https://hub.docker.com/_/python/
# https://hub.docker.com/_/alpine/

ARG PYTHON_IMAGE=python:3.9.3-alpine
FROM ${PYTHON_IMAGE} AS generator
ARG USER=10011001
LABEL maintainer="Tyler Tidman <tyler.tidman@draak.ca>"
WORKDIR /tmp/
COPY requirements.txt /tmp/
RUN pip install -r requirements.txt
COPY generate_template.py /tmp/
USER ${USER}
ENTRYPOINT ["python", "./generate_template.py"]
CMD ["--os_name=all"]

FROM alpine:latest AS fetcher
ARG PACKER_VERSION=1.7.2
LABEL maintainer="Tyler Tidman <tyler.tidman@draak.ca>"
WORKDIR /tmp/
USER ${USER}
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip

FROM alpine:latest AS builder
LABEL maintainer="Tyler Tidman <tyler.tidman@draak.ca>"
WORKDIR /tmp/
COPY --from=fetcher /tmp/packer /usr/local/bin
USER ${USER}
ENV BUILDER=vbox
ENV CHECKPOINT_DISABLE=1
ENV OS_NAME=debian
ENV OS_VERSION=10_buster
ENV PACKER_CACHE_DIR=packer_cache_dir
ENV TEMPLATE=base-uefi
ENV TEMPLATE_DIR=template
# ENTRYPOINT ["packer", "build", "-only=${BUILDER}", "-force", "${BUILD_OPTS}", "${TEMPLATE_DIR}/${OS_NAME}/${OS_VERSION}/${TEMPLATE}.json"]
