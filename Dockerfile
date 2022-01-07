FROM python:3.10

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone \
    --depth 1 \
    --filter=blob:none \
    --sparse \
    https://github.com/wesnoth/wesnoth \
    /data/wesnoth
WORKDIR /data/wesnoth
RUN git sparse-checkout set data/tools

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
