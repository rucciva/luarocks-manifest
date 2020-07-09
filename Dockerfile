FROM rucciva/golang:1.14.2-alpine AS modd

ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG VERSION="98a770274f90208fa968643d5ac7426258b4fad9"
ENV GO111MODULE=on
RUN go get -v github.com/cortesi/modd/cmd/modd@${VERSION}


FROM akorn/luarocks:lua5.1-alpine

COPY --from=modd /go/bin/modd /usr/local/bin/modd
RUN chmod +x /usr/local/bin/modd

ENV WORKDIR /srv/luarocks
WORKDIR ${WORKDIR}
COPY ./modd.conf ${WORKDIR}
VOLUME ${WORKDIR}/manifest

ENTRYPOINT ["/usr/local/bin/modd"]