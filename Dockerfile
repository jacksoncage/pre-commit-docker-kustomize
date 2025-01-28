FROM alpine:latest
RUN adduser kustomize -D \
  && apk add curl git openssh \
  && git config --global url.ssh://git@github.com/.insteadOf https://github.com/
RUN  curl -L --output /tmp/kustomize_v5.6.0_linux_amd64.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.6.0/kustomize_v5.6.0_linux_amd64.tar.gz \
  && echo "54e4031ddc4e7fc59e408da29e7c646e8e57b8088c51b84b3df0864f47b5148f  /tmp/kustomize_v5.6.0_linux_amd64.tar.gz" | sha256sum -c \
  && tar -xvzf /tmp/kustomize_v5.6.0_linux_amd64.tar.gz -C /usr/local/bin \
  && chmod +x /usr/local/bin/kustomize \
  && mkdir ~/.ssh \
  && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
USER kustomize
WORKDIR /src
