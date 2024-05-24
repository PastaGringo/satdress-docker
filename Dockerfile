FROM golang:1.21.8-alpine3.19 AS builder
RUN apk add git gcc musl-dev linux-headers
WORKDIR /opt/buid
RUN git clone --branch nwc https://github.com/braydonf/satdress.git /opt/buid
RUN go get
RUN go build
RUN go build ./cli/satdress-cli.go

FROM alpine:3.14
RUN apk add curl jq
COPY --from=builder /opt/buid/ /usr/local/bin/
EXPOSE 8080
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]