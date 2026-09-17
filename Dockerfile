# المرحلة الأولى المحدثة والمستقرة
FROM alpine:latest AS builder
RUN apk add --no-cache curl unzip

# تم تحديث خيارات curl هنا وتحديد الرابط المباشر للنسخة المستقرة لضمان التحميل السليم
RUN curl -L -f -o /tmp/v2ray.zip https://github.com \
    && mkdir /app \
    && unzip /tmp/v2ray.zip -d /app


# المرحلة الثانية: بناء الصورة النهائية الخفيفة جداً باسمك
FROM alpine:latest
LABEL maintainer="YourName <your-email@example.com>"

WORKDIR /app
COPY --from=builder /app/v2ray /app/v2ray
COPY --from=builder /app/geoip.dat /app/geoip.dat
COPY --from=builder /app/geosite.dat /app/geosite.dat
COPY config.json /app/config.json

# تثبيت المكاتب الأساسية والـ jq لتعديل المنافذ ديناميكياً
RUN apk add --no-cache ca-certificates jq

# سطر التشغيل الذكي: يقوم بتحديث منفذ (Port) جميع البروتوكولات داخل الـ JSON دفعة واحدة ليتوافق مع منفذ Cloud Run
CMD jq '.inbounds[].port = '"${PORT:-8080}"'' /app/config.json > /app/config_run.json && ./v2ray run -config /app/config_run.json
