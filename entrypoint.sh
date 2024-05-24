#!/bin/sh
echo
echo "╭────────────────────────────────────────────────────────╮"
echo "│  _____  ____  ______  ___    ____     ___  _____ _____ │";
echo "│ / ___/ /    ||      ||   \  |    \   /  _]/ ___// ___/ │";
echo "│(   \_ |  o  ||      ||    \ |  D  ) /  [_(   \_(   \_  │";
echo "│ \__  ||     ||_|  |_||  D  ||    / |    _]\__  |\__  | │";
echo "│ /  \ ||  _  |  |  |  |     ||    \ |   [_ /  \ |/  \ | │";
echo "│ \    ||  |  |  |  |  |     ||  .  \|     |\    |\    | │";
echo "│  \___||__|__|  |__|  |_____||__|\_||_____| \___| \___| │";
echo "│                                                        │";
echo "╰────────────────────────────────────────────────────────╯"
echo "                                                          ";
echo "Satdress nbd-wtf's GH repo (origin)           : https://github.com/nbd-wtf/satdress"
echo "Satdress braydonf's GH repo (fork; used here) : https://github.com/braydonf/satdress"
echo "Satdress docker image by PastaGringo          : https://github.com/PastaGringo/satdress-docker"
echo
echo "╭────────────────────────────╮"
echo "│ Docker Compose Env Vars ⤵️  │"
echo "╰────────────────────────────╯"
echo
echo "FORCE_RECONFIG    : $FORCE_RECONFIG"
echo "HOST              : $HOST"
echo "NOSTRPRIVATEKEY   : $NOSTRPRIVATEKEY"
echo "PORT              : $PORT"
echo "DOMAIN            : $DOMAIN"
echo "SITE_OWNER_URL    : $SITE_OWNER_URL"
echo "SITE_OWNER_NAME   : $SITE_OWNER_NAME"
echo "SITE_NAME         : $SITE_NAME"
echo "PHOENIXD_HOST     : $PHOENIXD_HOST"
echo "PHOENIXD_PORT     : $PHOENIXD_PORT"
echo "PHOENIXD_KEY      : $PHOENIXD_KEY"
echo "USER              : $USER"
echo "NWC_RELAY         : $NWC_RELAY"
echo
echo "╭────────────────────────╮"
echo "│ Testing Phoenixd... ⤵️  │"
echo "╰────────────────────────╯"
echo
echo "> Connecting to http://$PHOENIXD_HOST:$PHOENIXD_PORT/getinfo ..."
echo
response=$(curl -s "http://$PHOENIXD_HOST:$PHOENIXD_PORT/getinfo" -u :$PHOENIXD_KEY)
if echo "$response" | grep -q '"nodeId":'; then
    echo ">>> Phoenixd is UP ✅"
    echo 
    nodeId=$(echo "$response" | jq -r '.nodeId')
    chain=$(echo "$response" | jq -r '.chain')
    version=$(echo "$response" | jq -r '.version')
    echo "nodeId            : $nodeId"
    echo "chain             : $chain"
    echo "version           : $version"
else
    if echo "$response" | grep -q 'Invalid authentication'; then
        echo "❌ ERROR: Invalid authentication (use basic auth with the http password set in phoenix.conf)"
        echo
        echo ">>> Phoenixd is UP but auth failed because Phoenixd KEY is invalid."
        echo '    You need to retrieve the http-password from phoenix.conf (from $USER/.phoenix/phoenix.conf)'
        echo "    And update Env VAR PHOENIXD_KEY from docker-compose.yml file and docker compose again."
        echo "    Command: docker compose up -d && docker compose logs -f satdress"
    else
        echo "❌ ERROR: Phonixd is not reachable"
        echo
        echo ">>> Please verify if Phoenixd is running on host: $PHOENIXD_HOST"
        echo "    And restart the Docker container or update the docker-compose.yml file with Env VAR PHOENIXD_HOST updated with the correct value."
    fi
    echo
    echo "CTRL+C to exit the container"
    echo
    # Rester en cours d'exécution pour que le conteneur Docker ne s'arrête pas
    while :; do
        sleep 3600
    done
fi
echo
echo "╭─────────────────────────╮"
echo "│ Checking Satdress... ⤵️  │"
echo "╰─────────────────────────╯"
echo
path_config="config.yml"
echo "> Config.yml path : $path_config" 
echo
if [ -f "docker_setup_done" ] && [ "$FORCE_RECONFIG" != "true" ]; then
    echo ">>> Satdress has already been configured. Nothing to configure."
    echo
    echo "╭────────────────────────────────╮"
    echo "│ ⚡ Starting Satdress...  🚀 ⤵️  │"
    echo "╰────────────────────────────────╯"
    echo
    /usr/local/bin/satdress
else
    if [ "$FORCE_RECONFIG" = "true" ]; then
        echo ">>> FORCE_RECONFIG has been set to TRUE. Reconfiguring Satdress..."
    else
        echo ">>> Satdress is started for the first time! Configuring Satdress..."
    fi
    echo
    echo "╭───────────────────────────╮"
    echo "│ Generating NWC keys... ⤵️  │"
    echo "╰───────────────────────────╯"
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
    echo "╭────────────────────────────╮"
    echo "│ Configuring Satdress... ⤵️  │"
    echo "╰────────────────────────────╯"
    echo
    echo "> Creating config.yml..."
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
    echo "    nwcsecret: $private_key" >> $path_config
    echo "    nwcrelay: $NWC_RELAY" >> $path_config
    echo
    echo ">>> Configuration is done ✅ "
    touch docker_setup_done
    echo
    echo "╭────────────────────────────────╮"
    echo "│ ⚡ Starting Satdress...  🚀 ⤵️  │"
    echo "╰────────────────────────────────╯"
    echo
    nohup /usr/local/bin/satdress > satdress.out &
    sleep 10
    echo
    echo "╭──────────────────────────────╮"
    echo "│ Generating NWC QR Code... ⤵️  │"
    echo "╰──────────────────────────────╯"
    echo
    /usr/local/bin/satdress-cli nwc connect-qrcode --user $USER 
    echo
    echo "╭─────────────────────────────────────╮"
    echo "│ Generating NWC Connect String... ⤵️  │"
    echo "╰─────────────────────────────────────╯"
    echo
    /usr/local/bin/satdress-cli nwc connect-string --user $USER >> nwc.string
    nwc_string=$(cat nwc.string)
    echo $nwc_string
    echo
    id=$(echo $nwc_string | sed -n 's|nostr+walletconnect://\([^?]*\)?.*|\1|p')
    encoded_relay=$(echo $nwc_string | sed -n 's|.*relay=\([^&]*\)&.*|\1|p')
    relay=$(printf '%b' "${encoded_relay//%/\\x}")
    secret=$(echo $nwc_string | sed -n 's|.*secret=\(.*\)|\1|p')
    echo "ID            : $id"
    echo "Relay         : $relay"
    echo "Secret        : $secret"
    echo
    echo "╭─────────────────────────────────────────────────────╮"
    echo "│ Displaying Satdress log... (waiting new payment) ⤵️  │"
    echo "╰─────────────────────────────────────────────────────╯"
    echo
    tail -f satdress.out
fi