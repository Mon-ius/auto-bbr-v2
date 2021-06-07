ARG VARIANT=bionic
FROM buildpack-deps:${VARIANT}-curl
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=monius
ARG USER_UID=1000
ARG USER_GID=$USER_UID

FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}
COPY scripts/*.sh /root
RUN yes | unminimize 2>&1 \ 
    && bash /root/init-script.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get clean -y


FROM ubuntu:${VARIANT} as builder

ARG ZT_COMMIT=e8f7d5ef9e7ba6be0b2163cfa31f8817ba5b18f4

RUN yes | unminimize 2>&1 \
  && apt -qq update \
  && apt -qq install $(curl -fsSL git.io/bbrv2-ubuntu-2004) \
  && apt -qq build-dep linux \
  && apt -qq autoremove --purge \
  && apt -qq clean \
  && git clone --quiet https://github.com/zerotier/ZeroTierOne.git /src \
  && git -C src reset --quiet --hard ${ZT_COMMIT} \
  && cd /src \
  && make -f make-linux.mk

FROM ubuntu:${VARIANT}
LABEL version="1.6.5"
LABEL description="Code Space on ubuntu"

EXPOSE 9993/udp

COPY --from=builder /src/zerotier-one /usr/sbin/
RUN mkdir -p /var/lib/zerotier-one \
  && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-idtool \
  && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-cli
