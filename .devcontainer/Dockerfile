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