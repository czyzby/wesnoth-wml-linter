FROM python:3.10

RUN apt-get update >/dev/null && \
    apt-get upgrade -y >/dev/null && \
    apt-get install -y git

RUN echo "Cloning Wesnoth $WESNOTH_VERSION." && \
    git clone \
    --depth 1 \
    --filter=blob:none \
    --sparse \
    --single-branch --branch $WESNOTH_VERSION \
    https://github.com/wesnoth/wesnoth \
    /wesnoth
WORKDIR /wesnoth
RUN git sparse-checkout set data/tools/wmllint data/tools/wmlindent

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
