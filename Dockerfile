##################################
# DLRS Image - Dockerfile
# Author: Lucas Cantarelli
##################################
# 1 - Stage: Build
FROM alpine:latest AS BUILDER
LABEL maintainer="Lucas Cantarelli"
# Environment Variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV APP_PATH=/app
ENV POETRY_VIRTUALENV_PATH=${APP_PATH}/.venv
ENV POETRY_CACHE_DIR=${POETRY_VIRTUALENV_PATH}/.cache
# Workdir
WORKDIR ${APP_PATH}
# Commands
RUN apk add --update --no-cache \
	python3 \
	py3-pip \
	&& python -m venv $POETRY_VIRTUALENV_PATH \
	&& echo 'source $POETRY_VIRTUALENV_PATH/bin/activate' >> /etc/bash.bashrc \
	&& $POETRY_VIRTUALENV_PATH/bin/pip install --upgrade pip poetry
# Export PATH
ENV PATH="${POETRY_VIRTUALENV_PATH}/bin:${PATH}"
# 2 - Stage: Image
FROM alpine:latest AS IMAGE
LABEL maintainer="Lucas Cantarelli"
# Environment Variables
ENV APP_PATH=/app
ENV POETRY_VIRTUALENV_PATH=${APP_PATH}/.venv
ENV POETRY_CACHE_DIR=${POETRY_VIRTUALENV_PATH}/.cache
# Workdir
WORKDIR ${APP_PATH}
COPY ./entrypoint.sh ${APP_PATH}/entrypoint.sh
COPY --from=BUILDER ${POETRY_VIRTUALENV_PATH} ${POETRY_VIRTUALENV_PATH}
# Commands
RUN chmod +x entrypoint.sh
USER daemon
ENTRYPOINT [ "sh", "entrypoint.sh" ]
