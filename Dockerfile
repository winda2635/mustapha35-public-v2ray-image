FROM alpine:latest AS builder

RUN apk add --no-cache wget unzip

WORKDIR /tmp

RUN wget https://github.com

RUN mkdir /app

RUN unzip /tmp/v2ray-linux-64.zip -d /app

FROM alpine:latest
LABEL maintainer="mustapha35"

WORKDIR /app
COPY --from=builder /app/v2ray /app/v2ray
COPY --from=builder /app/geoip.dat /app/geoip.dat
COPY --from=builder /app/geosite.dat /app/geosite.dat
COPY config.json /app/config.json

RUN apk add --no-cache ca-certificates jq

CMD jq '.inbounds[].port = '"${PORT:-8080}"'' /app/config.json > /app/config_run.json && ./v2ray run -config /app/config_run.json
