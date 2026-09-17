FROM v2fly/v2fly-core:v4.45.2

LABEL maintainer="mustapha35"

WORKDIR /etc/v2ray

COPY config.json /etc/v2ray/config.json

USER root

RUN apk add --no-cache jq

CMD jq '.inbounds[].port = '"${PORT:-8080}"'' /etc/v2ray/config.json > /etc/v2ray/config_run.json && v2ray -config /etc/v2ray/config_run.json
