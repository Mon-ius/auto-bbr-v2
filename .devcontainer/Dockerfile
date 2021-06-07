ARG VARIANT=bionic
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=monius
ARG USER_UID=1000
ARG USER_GID=$USER_UID

FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}
COPY scripts/*.sh /tmp/library-scripts/
RUN yes | unminimize 2>&1 \ 
    && bash /tmp/library-scripts/init-script.sh"${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts