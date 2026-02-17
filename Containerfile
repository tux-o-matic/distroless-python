FROM quay.io/hummingbird/python:3.14

EXPOSE 8080

ENV PYTHON_VERSION=3.14 \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    CNB_USER_ID=1001 \
    CNB_GROUP_ID=0 \
    PIP_NO_CACHE_DIR=off \
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    APP_ROOT=/opt/app-root \
    HOME=/opt/app-root/src 
ENV PATH=$APP_ROOT/bin:$HOME/bin:$HOME/.local/bin:$PATH
ENV BASH_ENV=${APP_ROOT}/bin/activate \
    ENV=${APP_ROOT}/bin/activate \
    PROMPT_COMMAND=". ${APP_ROOT}/bin/activate"

LABEL io.k8s.display-name="Python 3.14" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,python,python314,python-314,rh-python314" \

USER 0

COPY .s2i/ $STI_SCRIPTS_PATH
COPY bin/ /usr/bin/

WORKDIR ${HOME}

ADD source ${APP_ROOT}

RUN python3.14 -m venv ${APP_ROOT} && \
    ${APP_ROOT}/bin/pip install /opt/wheels/pip-* && \
    rm -r /opt/wheels && \
    chown -R 1001:0 ${APP_ROOT} && \
    fix-permissions ${APP_ROOT} -P

USER 1001

CMD /usr/libexec/s2i/run
