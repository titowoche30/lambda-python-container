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
    libcurl \
    curl

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

# Install Lambda RIE
ARG LAMBDA_RIE_VERSION=1.12
RUN curl -Lo /usr/local/bin/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/download/v${LAMBDA_RIE_VERSION}/aws-lambda-rie
RUN chmod +x /usr/local/bin/aws-lambda-rie

# Multi-stage build: grab a fresh copy of the base image
FROM python:3.10.6-alpine

#This lib need to be added
#https://github.com/aws/aws-lambda-python-runtime-interface-client/issues/22
RUN apk update && apk upgrade --no-cache
RUN apk add --no-cache libstdc++

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}
COPY --from=build-image /usr/local/bin/aws-lambda-rie /usr/local/bin/aws-lambda-rie

COPY entry_script.sh /entry_script.sh
RUN chmod +x /entry_script.sh
ENTRYPOINT [ "/entry_script.sh" ]
CMD [ "main.handler" ]
