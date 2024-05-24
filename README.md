# satdress-docker

```sh
version: '3.8'
services:

### satdress ###

  satdress:
    container_name: satdress
    #image: pastagringo/satdress-docker
    build:
      context: .
    volumes:
      - ./satdress/db:/var/lib/lightning-address/
    environment:
      - FORCE_RECONFIG=false
      - HOST=0.0.0.0
      - PORT=8080
      - DOMAIN=plebes.ovh
      - SITE_OWNER_NAME=pastagringo
      - SITE_OWNER_URL=https://satdress.plebes.ovh
      - SITE_NAME=Fractalized
      - NOSTRPRIVATEKEY=19b598e0d3f738ac75c2fc1a33cd758abdf8f3bc53e4a7210dcfb31581a5321a # -> NSEC PRIVATE HEX: https://nostrtool.com
      - USER=pastagringo
      - PHOENIXD_HOST=phoenixbits
      - PHOENIXD_PORT=9740
      - PHOENIXD_KEY=1075d3c17d2625f518fc88b1a48e59464b0f7ad6cbaf7a233e0109804ff0eb66
      - NWC_RELAY=wss://nostr.fractalized.net
    # ports:
    #   - 8080:8080

```
