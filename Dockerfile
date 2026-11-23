FROM alpine:3.22

WORKDIR /app

RUN apk add --no-cache \
    ca-certificates \
    curl \
    gcompat \
    git \
    lua5.1

COPY . .

ENV TTTAM_CONTAINER=1
ENV LUA_PATH="/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;;"
ENV LUA_CPATH="/root/.luarocks/lib/lua/5.1/?.so;;"

RUN lua5.1 scripts/menu.lua --install

CMD ["./luvit", "src/scripts/main.lua"]
