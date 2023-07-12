FROM python:slim
LABEL maintainer="Lucas Cantarelli"

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Poetry PATH
ENV APP_PATH=/app
ENV POETRY_VIRTUALENV_PATH=${APP_PATH}/.venv
ENV POETRY_CACHE_DIR=${POETRY_VIRTUALENV_PATH}/.cache
WORKDIR /app

# Expose port
EXPOSE 5000

# Create virtualenv
RUN python -m venv $POETRY_VIRTUALENV_PATH \
	&& echo 'source $POETRY_VIRTUALENV_PATH/bin/activate' >> ~/.bashrc \
	&& $POETRY_VIRTUALENV_PATH/bin/pip install --upgrade pip poetry

# Register Poetry in PATH
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

USER daemon
CMD ["/bin/bash"]
