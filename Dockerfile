FROM golang:1.21.8-alpine3.19 AS builder
RUN apk add git gcc musl-dev linux-headers
WORKDIR /opt/buid
RUN git clone https://github.com/braydonf/satdress.git /opt/buid
RUN go get
RUN go build
FROM alpine:3.14
COPY --from=builder /opt/buid/satdress /usr/local/bin/
EXPOSE 17422
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]