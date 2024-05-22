#!/bin/sh
echo
echo "------------"
echo "  SATDRESS  "
echo "------------"
echo
echo "Github repo: https://github.com/braydonf/satdress"
echo "Satdress docker image by PastaGringo: https://github.com/PastaGringo/satdress-docker"
echo
echo "---------------------------"
echo "  Docker Compose Env Vars"
echo "---------------------------"
echo
echo "HOST              : $HOST"
echo "NOSTRPRIVATEKEY   : $NOSTRPRIVATEKEY"
echo "PORT              : $PORT"
echo "DOMAIN            : $DOMAIN"
echo "SECRET            : $SECRET"
echo "SITE_OWNER_URL    : $SITE_OWNER_URL"
echo "SITE_OWNER_NAME   : $SITE_OWNER_NAME"
echo "SITE_NAME         : $SITE_NAME"
echo "PHOENIXD_HOST     : $PHOENIXD_HOST"
echo "PHOENIXD_PORT     : $PHOENIXD_PORT"
echo "PHOENIXD_KEY      : $PHOENIXD_KEY"
echo "USER_ADDRESS      : $USER_ADDRESS"
echo
echo "------------------------"
echo "  Checking Satdress..."
echo "------------------------"
echo
if [ -f "docker_setup_done" ]; then
    echo ">>> Satdress has already been configured. Nothing to configure."
    echo
    echo "------------------------"
    echo "  Starting Satdress..."
    echo "------------------------"
    echo
    /usr/local/bin/satdress
else
    echo "> Satdress is started for the first time!"
    echo "> Configuring Satdress..."
    echo "- Creating config.yml..."
    echo "host: $HOST" >> config.yml
    echo "port: $PORT" >> config.yml
    echo "domain: $DOMAIN" >> config.yml
    echo "siteownername: $SITE_OWNER_NAME" >> config.yml
    echo "siteownerurl: $SITE_OWNER_URL" >> config.yml
    echo "sitename: $SITE_NAME" >> config.yml
    echo "nostrprivatekey: $NOSTRPRIVATEKEY" >> config.yml
    echo ""  >> config.yml
    echo "users:" >> config.yml
    echo "  - name: $USER_ADDRESS" >> config.yml
    echo "    kind: phoenix" >> config.yml
    echo "    host: $PHOENIXD_HOST:$PHOENIXD_PORT" >> config.yml
    echo "    key: $PHOENIXD_KEY" >> config.yml
    echo "> Configuration is done ✅ "
    echo
    echo "------------------------"
    echo "  Starting Satdress..."
    echo "------------------------"
    echo
    /usr/local/bin/satdress
fi