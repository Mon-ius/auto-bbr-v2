ARG VARIANT=bionic
FROM ubuntu:${VARIANT} as builder
ARG ZT_COMMIT=e8f7d5ef9e7ba6be0b2163cfa31f8817ba5b18f4
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN yes | unminimize 2>&1 \
  && sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update && apt-get install -y curl && apt-get install $(curl -fsSL git.io/bbrv2-ubuntu-2004) -y 
RUN apt-get -qq build-dep linux -y 
RUN apt -qq autoremove --purge \
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

RUN zerotier-one -d
RUN zerotier-cli join 1c33c1ced09a6faf
