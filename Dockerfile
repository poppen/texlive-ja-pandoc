# syntax=docker/dockerfile:1.7
FROM paperist/texlive-ja:latest

ARG PANDOC_VERSION=3.11
ARG TARGETARCH

LABEL org.opencontainers.image.source="https://github.com/poppen/texlive-ja-pandoc" \
      org.opencontainers.image.description="paperist/texlive-ja + pandoc ${PANDOC_VERSION}" \
      org.opencontainers.image.licenses="MIT"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        make \
        fonts-noto-cjk \
        fonts-noto-cjk-extra; \
    curl -fsSL -o /tmp/pandoc.deb \
        "https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-${TARGETARCH}.deb"; \
    apt-get install -y --no-install-recommends /tmp/pandoc.deb; \
    rm /tmp/pandoc.deb; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    pandoc --version
