#!/bin/bash
########################################################################
# Project           : DLRS - Docker Image Base
# Maintainer        : Lucas Cantarelli
########################################################################

echo "DLRS - Docker Image Base"
echo ""
echo "Image: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2)"
echo "Version: $(cat /etc/os-release | grep VERSION_ID | cut -d '=' -f2)"
echo "Workdir: ${APP_PATH}"
echo "Python Version: $(python --version)"
echo "Poetry Version: $(poetry --version)"
echo "Poetry Virtualenv: ${POETRY_VIRTUALENV_PATH}"