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
ENV LUA_PATH="/app/deps/share/lua/5.1/?.lua;/app/deps/share/lua/5.1/?/init.lua;;"
ENV LUA_CPATH="/app/deps/lib/lua/5.1/?.so;;"

RUN lua scripts/menu.lua --install

CMD ["./luvit", "src/scripts/main.lua"]
