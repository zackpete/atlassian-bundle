#!/bin/sh

set -o errexit
set -o nounset

for i in \
"$BAMBOO_INSTALL_DIR" "$BITBUCKET_INSTALL_DIR" "$CONFLUENCE_INSTALL_DIR" "$JIRA_INSTALL_DIR"; do
    mkdir -p "$i/conf/Catalina"
    chmod -R 700 "$i/conf/Catalina"
    chmod -R 700 "$i/logs"
    chmod -R 700 "$i/temp"
    chmod -R 700 "$i/work"
    chown -R ${RUN_USER}:${RUN_GROUP} "$i/"
done

cat > /usr/local/share/enabled_apps <<EOF
"${BAMBOO_INSTALL_DIR}/bin/start-bamboo.sh" -fg
"${BITBUCKET_INSTALL_DIR}/bin/start-bitbucket.sh" -fg
"${CONFLUENCE_INSTALL_DIR}/bin/start-confluence.sh" -fg
"${JIRA_INSTALL_DIR}/bin/start-jira.sh" -fg
EOF

cat > /usr/local/bin/start-apps.sh <<EOF
#!/bin/sh
set -o errexit
cat /usr/local/share/enabled_apps | parallel --no-notice --termseq TERM,10000,KILL,100
EOF

chmod 755 /usr/local/bin/start-apps.sh
