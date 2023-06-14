# Define function directory
ARG FUNCTION_DIR="/function"

FROM python:3.10.6-alpine as build-image

# Install aws-lambda-cpp build dependencies
RUN apk update && apk upgrade --no-cache
RUN apk add --no-cache \
    libstdc++ \
    build-base \
    libtool \
    autoconf \
    automake \
    libexecinfo-dev \
    libffi-dev \
    linux-headers \
    musl-dev \
    openssl-dev \
    make \
    cmake \
    libcurl


# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Create function directory
RUN mkdir -pv ${FUNCTION_DIR}

# Copy function code
COPY app/* ${FUNCTION_DIR}
COPY requirements.txt ${FUNCTION_DIR}

# Install the runtime interface client
RUN pip install \
        --target ${FUNCTION_DIR} \
        -r ${FUNCTION_DIR}/requirements.txt

# Multi-stage build: grab a fresh copy of the base image
FROM python:3.10.6-alpine

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "main.handler" ]
