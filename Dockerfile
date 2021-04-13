FROM debian:buster-slim

ARG GITHUB_RUNNER_VERSION="v2.277.1"

ENV RUNNER_NAME "runner"
ENV GITHUB_PAT ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
ENV RUNNER_WORKDIR "_work"

RUN apt-get update \
    && apt-get install -y \
        curl \
        sudo \
        git \
        jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m github \
    && usermod -aG sudo github \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER github
WORKDIR /home/github

# RUN curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar xz \
#    && sudo ./bin/installdependencies.sh

# Download the latest runner package
# RUN curl -O -L https://github.com/actions/runner/releases/download/v2.277.1/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar xz && sudo ./bin/installdependencies.sh

# Download the latest runner package
RUN curl -O -L https://github.com/actions/runner/releases/download/v2.277.1/actions-runner-linux-x64-2.277.1.tar.gz | tar xzf ./actions-runner-linux-x64-2.277.1.tar.gz

RUN ls -lah
RUN pwd

COPY --chown=github:github entrypoint.sh ./entrypoint.sh
RUN sudo chmod u+x ./entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]