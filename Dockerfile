FROM alpine:3.20.3
ARG TARGETARCH

ADD src/install.sh install.sh
RUN sh install.sh && rm install.sh



ENV POSTGRES_DATABASE ''
ENV POSTGRES_HOST ''
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER ''
ENV POSTGRES_PASSWORD ''
ENV PGDUMP_EXTRA_OPTS ''
ENV B2_KEY_ID ''
ENV B2_APPLICATION_KEY ''
ENV B2_BUCKET ''
ENV B2_PREFIX ''
ENV SCHEDULE ''
ENV PASSPHRASE ''
ENV BACKUP_KEEP_DAYS ''

ADD src/run.sh run.sh
ADD src/env.sh env.sh
ADD src/backup.sh backup.sh
ADD src/restore.sh restore.sh

CMD ["sh", "run.sh"]
