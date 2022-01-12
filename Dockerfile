FROM python:3.10-slim

RUN apt-get update >/dev/null && \
    apt-get upgrade -y >/dev/null && \
    apt-get install -y git

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
