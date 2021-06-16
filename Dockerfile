FROM monius/build-system-ubuntu:advanced

RUN export DEBIAN_FRONTEND=noninteractive \
  && sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list \
  && sudo apt-get update --allow-unauthenticated \ 
  && sudo apt-get install $(curl -fsSL git.io/bbr-v2alpha-ubuntu-hirsute) -y \
  && sudo apt-get -qq build-dep linux -y \
  && sudo apt-get -qq autoremove --purge \
  && sudo apt-get -qq clean 

RUN sudo sed -Ei 's/required /sufficient /' /etc/pam.d/chsh \
  && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  && curl -L git.io/antigen > ~/.antigen.zsh \ 
  && curl -L git.io/ubuntu-hirsute-antigenrc > ~/.antigenrc \
  && curl -L git.io/ubuntu-hirsute-p10k > ~/.p10k.zsh \
  && curl -L git.io/ubuntu-hirsute-zshrc > ~/.zshrc \
  && echo "{\n}" > ~/package.json
  && chsh -s /bin/zsh