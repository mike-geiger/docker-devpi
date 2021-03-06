#
FROM python:3.7.3
LABEL maintainer="https://github.com/muccg/"

#ARG ARG_DEVPI_SERVER_VERSION=4.5.0
#ARG ARG_DEVPI_WEB_VERSION=3.3.0
#ARG ARG_DEVPI_CLIENT_VERSION=4.0.2

#ENV DEVPI_SERVER_VERSION $ARG_DEVPI_SERVER_VERSION
#ENV DEVPI_WEB_VERSION $ARG_DEVPI_WEB_VERSION
#ENV DEVPI_CLIENT_VERSION $ARG_DEVPI_CLIENT_VERSION
#ENV PIP_NO_CACHE_DIR="off"
#ENV PIP_INDEX_URL="http://192.168.29.147:3141/packages/stable2/+simple"
#ENV PIP_TRUSTED_HOST="192.168.29.147"
#ENV VIRTUAL_ENV /env

# devpi user
RUN addgroup --system --gid 1000 devpi \
    && adduser --disabled-password --system --uid 1000 --home /data --shell /sbin/nologin --gid 1000 devpi

# create a virtual env in $VIRTUAL_ENV, ensure it respects pip version
#RUN pip install virtualenv \
#    && virtualenv $VIRTUAL_ENV \
#    && $VIRTUAL_ENV/bin/pip install pip==$PYTHON_PIP_VERSION
#ENV PATH $VIRTUAL_ENV/bin:$PATH

#RUN pip install \
#    "devpi-client==${DEVPI_CLIENT_VERSION}" \
#    "devpi-web==${DEVPI_WEB_VERSION}" \
#    "devpi-server==${DEVPI_SERVER_VERSION}"

RUN pip install devpi-server
RUN pip install devpi-web
RUN pip install devpi-client 

EXPOSE 3141
VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER devpi
ENV HOME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["devpi"]
