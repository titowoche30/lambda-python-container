# Define function directory
ARG FUNCTION_DIR="/function"

FROM python:3.10.6-buster as build-image

# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
  apt-get install -y \
  g++ \
  make \
  cmake \
  unzip \
  libcurl4-openssl-dev


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
FROM python:3.10.6-buster

ARG LAMBDA_RIE_VERSION=1.12

RUN curl -Lo /usr/local/bin/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/download/v${LAMBDA_RIE_VERSION}/aws-lambda-rie
RUN chmod +x /usr/local/bin/aws-lambda-rie

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the build image dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

COPY entry_script.sh /entry_script.sh
RUN chmod +x /entry_script.sh
ENTRYPOINT [ "/entry_script.sh" ]
CMD [ "main.handler" ]
