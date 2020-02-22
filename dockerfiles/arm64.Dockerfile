FROM multiarch/qemu-user-static:latest as qemu-user-static

RUN mkdir /qemu && touch /qemu/qemu-x86_64-dummy && cp /usr/bin/qemu-* /qemu/

FROM arm64v8/alpine:latest

ARG ARCH=aarch6

COPY --from=qemu-user-static /qemu/qemu-${ARCH}-* /usr/bin/

# install all required packages
RUN apk add --update --no-cache; \
    apk add --no-cache wget git jq python3 bash openssh unzip; \
    pip3 install --upgrade pip; \
    apk add --no-cache --virtual .buil-deps gcc python3-dev musl-dev alpine-sdk libffi-dev openssl-dev; \
    pip3 install ansible; \
    apk del .build-deps; \

    # Download terraform
    # Terraform not available in arm64 arch
    # wget https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_arm.zip; \
    # unzip terraform_0.12.21_linux_arm.zip; \
    # chmod +x terraform; \
    # mv terraform /usr/local/bin/terraform; \
    # rm -rf terraform_0.12.21_linux_arm.zip; \

    # Download packer
    wget https://releases.hashicorp.com/packer/1.5.4/packer_1.5.4_linux_arm64.zip; \
    unzip packer_1.5.4_linux_arm64.zip; \
    chmod +x packer; \
    mv packer /usr/local/bin/packer; \
    rm -rf packer_1.5.4_linux_arm64.zip;