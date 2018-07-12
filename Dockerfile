FROM alpine

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="helm-kubectl" \
      org.label-schema.url="https://hub.docker.com/r/imduffy15/helm-kubectl/" \
      org.label-schema.vcs-url="https://github.com/imduffy15/helm-kubectl" \
      org.label-schema.build-date=$BUILD_DATE

# Note: Latest version of kubectl may be found at:
# https://aur.archlinux.org/packages/kubectl-bin/
ENV KUBE_LATEST_VERSION="v1.10.2"

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v2.8.2"

# Note: Latest version of sigil may be found at:
# https://github.com/gliderlabs/sigil/releases
ENV SIGIL_VERSION="0.4.0"

RUN apk add --no-cache ca-certificates \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && wget -q https://github.com/gliderlabs/sigil/releases/download/v${SIGIL_VERSION}/sigil_${SIGIL_VERSION}_Linux_x86_64.tgz -O - | tar -xzO sigil > /usr/local/bin/sigil \
    && chmod +x /usr/local/bin/sigil

ENV CLOUD_SDK_VERSION 203.0.0

ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

# Install JQ
RUN apk add --no-cache jq

# Install DNS tools
RUN apk add --no-cache bind-tools
