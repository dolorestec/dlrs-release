##################################
# DLRS Image - Dockerfile
# Author: Lucas Cantarelli
##################################
# 1 - Stage: Build
FROM python:slim AS builder
LABEL stage=builder
WORKDIR /app
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
# Poetry PATH
ENV APP_PATH=/app
ENV POETRY_VIRTUALENV_PATH=${APP_PATH}/.venv
ENV POETRY_CACHE_DIR=${POETRY_VIRTUALENV_PATH}/.cache
WORKDIR ${APP_PATH}
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
	&& python -m venv $POETRY_VIRTUALENV_PATH \
	&& echo 'source $POETRY_VIRTUALENV_PATH/bin/activate' >> /etc/bash.bashrc \
	&& $POETRY_VIRTUALENV_PATH/bin/pip install --upgrade pip poetry \
	&& apt remove -y build-essential \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*
ENV PATH="${POETRY_VIRTUALENV_PATH}/bin:${PATH}"

# MOTD - Message of the day
RUN echo "\
===================================================================\n\
Image: Flask Poetry\n\
Workdir: ${APP_PATH}\n\
Poetry Virtualenv: ${POETRY_VIRTUALENV_PATH}\n\
Poetry Cache: ${POETRY_CACHE_DIR}\n\
Poetry Version: $(poetry --version)\n\
Python Version: $(python --version)\n\
===================================================================\n\
" > /etc/motd && echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc;

# 2 - Stage: Image
FROM python:slim AS image
LABEL stage=image	
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
# Poetry PATH
ENV APP_PATH=/app
ENV POETRY_VIRTUALENV_PATH=${APP_PATH}/.venv
ENV POETRY_CACHE_DIR=${POETRY_VIRTUALENV_PATH}/.cache
ENV MOTD=/etc/motd
ENV BASHRC=/etc/bash.bashrc

COPY --from=builder ${APP_PATH} ${APP_PATH}
COPY --from=builder ${MOTD} ${MOTD}
COPY --from=builder ${BASHRC} ${BASHRC}

USER daemon
CMD ["/bin/bash"]
