FROM alpine:latest

# Create a non-root user named 'kustomize' and install necessary packages
RUN adduser -D kustomize \
    && apk add --no-cache curl git openssh

# Configure Git to use SSH instead of HTTPS for GitHub
RUN git config --global url.ssh://git@github.com/.insteadOf https://github.com/

# Install kustomize and ksops
RUN \
    # Install kustomize
    curl -L --output /tmp/kustomize_v5.6.0_linux_amd64.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.6.0/kustomize_v5.6.0_linux_amd64.tar.gz \
    && echo "54e4031ddc4e7fc59e408da29e7c646e8e57b8088c51b84b3df0864f47b5148f  /tmp/kustomize_v5.6.0_linux_amd64.tar.gz" | sha256sum -c - \
    && tar -xvzf /tmp/kustomize_v5.6.0_linux_amd64.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/kustomize \
    && rm /tmp/kustomize_v5.6.0_linux_amd64.tar.gz \
    \
    # Install ksops
    && curl -L --output /tmp/ksops_latest_Linux_x86_64.tar.gz https://github.com/viaduct-ai/kustomize-sops/releases/download/v4.3.3/ksops_latest_Linux_x86_64.tar.gz \
    && echo "1ed1cd42c77afced1245b54ec211b8a38b61c1f23bbfa51fa361d7f777dcb0f8  /tmp/ksops_latest_Linux_x86_64.tar.gz" | sha256sum -c - \
    && tar -xvzf /tmp/ksops_latest_Linux_x86_64.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/ksops \
    && rm /tmp/ksops_latest_Linux_x86_64.tar.gz \
    \
    # Set up SSH
    && mkdir /home/kustomize/.ssh \
    && ssh-keyscan -t rsa github.com >> /home/kustomize/.ssh/known_hosts \
    && chown -R kustomize:kustomize /home/kustomize/.ssh

# Switch to the non-root user
USER kustomize

# Set the working directory
WORKDIR /src
