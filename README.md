# satdress-docker

```sh
version: '3.8'
services:

### satdress ###

  satdress:
    container_name: satdress
    #image: pastagringo/satdress-docker
    build:
      context: /home/pastadmin/DEV/PLAY/satdress-docker
    volumes:
      - ./satdress/db:/var/lib/lightning-address/
    environment:
      - HOST=0.0.0.0
      - PORT=8080
      - DOMAIN=plebes.ovh
      - SITE_OWNER_NAME=pastagringo
      - SITE_OWNER_URL=https://satdress.plebes.ovh
      - SITE_NAME=Fractalized
      - NOSTRPRIVATEKEY=19b598e0d3f738ac75c2fc1a33cd758abdf8f3bc53e4a7210dcfb31581aXXXXX # -> NSEC PRIVATE HEX: https://nostrtool.com
      - USER=pastagringo
      - PHOENIXD_HOST=phoenixbits
      - PHOENIXD_PORT=9740
      - PHOENIXD_KEY=e722ed49e425653c7d54283c9e1181cfcbe9b29848590c28ffcef6f944dXXXXX
      # - SECRET=fd2dd6014b421ad403bcc84be83b9bf3901404957e12f9bf7f27db9c840XXXXX
      - NWC_RELAY=wss://nostr.fractalized.net
    # ports:
    #   - 8080:8080
```
