FROM monius/build-system-ubuntu:base

ARG USER=monius
ENV NETWORK=''
ENV PUBLIC_KEY=''

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list \
  && apt-get update \ 
  && apt-get install -y apt-utils curl \
  && apt-get install -y --no-install-recommends tzdata \
  && apt-get dist-upgrade -y \
  && apt-get install $(curl -fsSL git.io/bbr-v2alpha-ubuntu-hirsute) -y \
  && apt-get -qq build-dep linux -y \
  && apt-get -qq autoremove --purge \
  && apt-get -qq clean

RUN useradd -rm -d /home/$USER -s /bin/bash -g root -G sudo -u 1000 $USER 
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN service ssh start

COPY entrypoint.sh /run/entrypoint.sh
ENTRYPOINT ["/run/entrypoint.sh"]

USER $USER
WORKDIR /home/$USER

RUN sudo sed -Ei 's/required /sufficient /' /etc/pam.d/chsh \
  && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  && curl -L git.io/antigen > ~/.antigen.zsh \ 
  && curl -L git.io/ubuntu-hirsute-antigenrc > ~/.antigenrc \
  && curl -L git.io/ubuntu-hirsute-p10k > ~/.p10k.zsh \
  && curl -L git.io/ubuntu-hirsute-zshrc > ~/.zshrc \
  && echo "{\n}" > ~/package.json \
  && chsh -s /bin/zsh 

EXPOSE 9993/udp

STOPSIGNAL SIGQUIT