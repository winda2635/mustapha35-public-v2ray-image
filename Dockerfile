FROM v2fly/v2fly-core:v4.45.2 AS official

FROM alpine:latest
LABEL maintainer="mustapha35"

WORKDIR /app

COPY --from=official /usr/bin/v2ray /app/v2ray
COPY --from=official /usr/bin/v2ctl /app/v2ctl
COPY --from=official /usr/bin/geoip.dat /app/geoip.dat
COPY --from=official /usr/bin/geosite.dat /app/geosite.dat
COPY config.json /app/config.json

RUN apk add --no-cache ca-certificates jq

CMD jq '.inbounds[].port = '"${PORT:-8080}"'' /app/config.json > /app/config_run.json && ./v2ray run -config /app/config_run.json
