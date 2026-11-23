FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LUA_PATH="/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;;"
ENV LUA_CPATH="/usr/local/lib/lua/5.1/?.so;;"
ENV PATH="/opt/yt-dlp/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    ffmpeg \
    git \
    liblua5.1-0-dev \
    libsqlite3-dev \
    luarocks \
    lua5.1 \
    python3 \
    python3-venv \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/yt-dlp \
    && /opt/yt-dlp/bin/pip install --no-cache-dir yt-dlp

WORKDIR /app

COPY . .

RUN curl -fL https://github.com/luvit/lit/raw/master/get-lit.sh -o /tmp/get-lit.sh \
    && sh /tmp/get-lit.sh \
    && rm /tmp/get-lit.sh

RUN set -eux; \
    for package in \
        SinisterRectus/discordia \
        Bilal2453/discordia-interactions \
        Bilal2453/discordia-components \
        GitSparTV/discordia-slash \
        creationix/secure-socket \
        creationix/sha1 \
        creationix/base64 \
        creationix/coro-channel \
        creationix/coro-fs \
        creationix/coro-http \
        creationix/coro-net \
        creationix/coro-websocket \
        creationix/coro-wrapper \
        creationix/http-codec \
        luvit/json \
        creationix/los \
        luvit/pathjoin \
        luvit/pretty-print \
        creationix/resource \
        creationix/websocket-codec; \
    do \
        ./lit install "$package"; \
    done

RUN luarocks --lua-version=5.1 --tree=/usr/local install lsqlite3 \
    && luarocks --lua-version=5.1 --tree=/usr/local install tinytoml

CMD ["./luvit", "src/scripts/main.lua"]
