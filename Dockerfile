ARG VARIANT=bionic
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends <your-package-list-here>