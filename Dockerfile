FROM alpine:3.19 AS DEPENDENCIES

WORKDIR /downloads

RUN apk add curl && \
    curl --location --silent --output kustomize_v5.4.1_linux_amd64.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.4.1/kustomize_v5.4.1_linux_amd64.tar.gz &&     \
    echo "3d659a80398658d4fec4ec4ca184b432afa1d86451a60be63ca6e14311fc1c42 kustomize_v5.4.1_linux_amd64.tar.gz" | sha256sum -c && \
    tar -xzf kustomize_v5.4.1_linux_amd64.tar.gz

FROM alpine:3.19

WORKDIR /src

RUN apk add git openssh && \
    git config --global url.ssh://git@github.com/.insteadOf https://github.com/ && \
    mkdir ~/.ssh && \
    ssh-keyscan github.com >> /etc/ssh/ssh_known_hosts

COPY --from=DEPENDENCIES /downloads/kustomize /usr/local/bin/

USER nobody
