FROM python:3.10-slim

RUN apt-get update >/dev/null && \
    apt-get upgrade -y >/dev/null && \
    apt-get install -y git enchant-2 hunspell hunspell-en-us

RUN pip install pyenchant~=3.0

COPY report.py /report.py
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
