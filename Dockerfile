FROM frolvlad/alpine-oraclejdk8

ENV RUN_USER daemon
ENV RUN_GROUP daemon

ENV BAMBOO_VERSION           5.12.2.1
ENV BITBUCKET_VERSION        4.7.1
ENV CONFLUENCE_VERSION       5.10.1
ENV JIRA_VERSION             7.1.9

ENV BAMBOO_HOME              /var/atlassian/application-data/bamboo
ENV BAMBOO_INSTALL_DIR       /opt/atlassian/bamboo
ENV BAMBOO_URL               https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz

ENV BITBUCKET_HOME           /var/atlassian/application-data/bitbucket
ENV BITBUCKET_INSTALL_DIR    /opt/atlassian/bitbucket
ENV BITBUCKET_URL            https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz

ENV CONFLUENCE_HOME          /var/atlassian/application-data/confluence
ENV CONFLUENCE_INSTALL_DIR   /opt/atlassian/confluence
ENV CONFLUENCE_URL           https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz

ENV JIRA_HOME                /var/atlassian/application-data/jira
ENV JIRA_INSTALL_DIR         /opt/atlassian/jira
ENV JIRA_URL                 https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}.tar.gz

COPY install.sh /install.sh
RUN apk add --update bash curl git parallel perl tar \
    && rm -fr /var/cache/apk/* \
    && mkdir -p ${BAMBOO_INSTALL_DIR} \
    && mkdir -p ${BITBUCKET_INSTALL_DIR} \
    && mkdir -p ${CONFLUENCE_INSTALL_DIR} \
    && mkdir -p ${JIRA_INSTALL_DIR} \
    && curl -L ${BAMBOO_URL} | tar -xz --strip=1 -C "$BAMBOO_INSTALL_DIR" \
    && curl -L ${BITBUCKET_URL} | tar -xz --strip=1 -C "$BITBUCKET_INSTALL_DIR" \
    && curl -L ${CONFLUENCE_URL} | tar -xz --strip=1 -C "$CONFLUENCE_INSTALL_DIR" \
    && curl -L ${JIRA_URL} | tar -xz --strip=1 -C "$JIRA_INSTALL_DIR" \
    && echo "confluence.home=${CONFLUENCE_HOME}" > "${CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/classes/confluence-init.properties" \
    && chmod a+x /install.sh \
    && /install.sh \
    && rm /install.sh

USER ${RUN_USER}:${RUN_GROUP}
CMD ["/usr/local/bin/start-apps.sh"]
