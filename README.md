# satdress-docker

```sh
version: '3.8'
services:

### satdress ###

  satdress:
    container_name: satdress
    image: pastagringo/satdress-docker
    # build:
      # context: /home/pastadmin/DEV/BashGitBuildPush/PLAY/satdress
    environment:
      - HOST=0.0.0.0
      - NOSTRPRIVATEKEY=YourNsec
      - PORT=8080
      - DOMAIN=fractalized.net
      - SECRET=fd2dd6014b421ad403bcc84be83b9bf3901404957e12f9bf7f27db9c8402cf0d
      - SITE_OWNER_URL=https://satdress.fractalized.net
      - SITE_OWNER_NAME=pastagringo
      - SITE_NAME=Fractalized
      - PHOENIXD_HOST=phoenixbits
      - PHOENIXD_PORT=9740
      - PHOENIXD_KEY=YourPhoenixdKey
      - USER_ADDRESS=pastagringo
    # ports:
    #   - 8080:8080
```
