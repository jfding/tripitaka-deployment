FROM python:3.6-slim-stretch

RUN apt-get update && apt-get install -y \
    git \
    rsync \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /scripts
COPY monit.sh /scripts
COPY init-runtime-and-run.sh /scripts

CMD /scripts/monit.sh
