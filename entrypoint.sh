#!/bin/sh
echo
echo "  _____  ____  ______  ___    ____     ___  _____ _____";
echo " / ___/ /    ||      ||   \  |    \   /  _]/ ___// ___/";
echo "(   \_ |  o  ||      ||    \ |  D  ) /  [_(   \_(   \_ ";
echo " \__  ||     ||_|  |_||  D  ||    / |    _]\__  |\__  |";
echo " /  \ ||  _  |  |  |  |     ||    \ |   [_ /  \ |/  \ |";
echo " \    ||  |  |  |  |  |     ||  .  \|     |\    |\    |";
echo "  \___||__|__|  |__|  |_____||__|\_||_____| \___| \___|";
echo "                                                       ";
echo "Satdress github repo                  : https://github.com/braydonf/satdress"
echo "Satdress docker image by PastaGringo  : https://github.com/PastaGringo/satdress-docker"
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
echo "USER              : $USER"
echo "NWC_RELAY         : $NWC_RELAY"
echo
echo "------------------------"
echo "  Checking Satdress..."
echo "------------------------"
echo
path_config="config.yml"
echo "> Config.yml path   : $path_config" 
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
    echo ">>> Satdress is started for the first time!"
    echo
    echo "------------------------"
    echo "  Generating NWC keys..."
    echo "------------------------"
    echo
    /usr/local/bin/satdress-cli nwc keygen >> nwc.keys
    private_key=$(grep "private key:" "nwc.keys" | cut -d ' ' -f 3)
    private_key_hex=$(grep "public key:" "nwc.keys" | cut -d ' ' -f 3)
    nsec=$(grep "nsec:" "nwc.keys" | cut -d ' ' -f 2)
    npub=$(grep "npub:" "nwc.keys" | cut -d ' ' -f 2)
    echo "Private key       : $private_key"
    echo "Private key Hex   : $private_key_hex"
    echo "Nsec              : $nsec"
    echo "Npub              : $npub"
    echo
    echo "> Configuring Satdress..."
    echo "- Creating config.yml..."
    echo "host: $HOST" >> $path_config
    echo "port: $PORT" >> $path_config
    echo "domain: $DOMAIN" >> $path_config
    echo "siteownername: $SITE_OWNER_NAME" >> $path_config
    echo "siteownerurl: $SITE_OWNER_URL" >> $path_config
    echo "sitename: $SITE_NAME" >> $path_config
    echo "nostrprivatekey: $NOSTRPRIVATEKEY" >> $path_config
    echo ""  >> $path_config
    echo "users:" >> $path_config
    echo "  - name: $USER" >> $path_config
    echo "    kind: phoenix" >> $path_config
    echo "    host: $PHOENIXD_HOST:$PHOENIXD_PORT" >> $path_config
    echo "    key: $PHOENIXD_KEY" >> $path_config
    echo "    nwcsecret: $private_key_hex" >> $path_config
    echo "    nwcrelay: $NWC_RELAY" >> $path_config
    echo
    echo "> Configuration is done ✅ "
    echo
    echo "--------------------------"
    echo "  Starting Satdress... ⚡"
    echo "--------------------------"
    echo
    nohup /usr/local/bin/satdress > satdress.out &
    sleep 10
    echo
    echo "-----------------------------"
    echo "  Generating NWC QR Code..."
    echo "-----------------------------"
    echo
    /usr/local/bin/satdress-cli nwc connect-qrcode --user $USER
    echo
    echo "------------------------------------"
    echo "  Generating NWC Connect String..."
    echo "------------------------------------"
    echo
    /usr/local/bin/satdress-cli nwc connect-string --user $USER
    echo
    echo "----------------------------------------------------"
    echo "  Displaying Satdress log... (waiting new payment)"
    echo "----------------------------------------------------"
    echo
    tail -f satdress.out
fi