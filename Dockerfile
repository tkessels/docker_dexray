FROM alpine:latest AS builder
RUN apk add -u perl-app-cpanminus apkbuild-cpan perl-dev build-base perl
RUN cpanm Crypt::RC4
RUN cpanm Digest::CRC
RUN cpanm Crypt::Blowfish
RUN cpanm Archive::Zip --force
RUN cpanm OLE::Storage_Lite
RUN apk del perl-app-cpanminus apkbuild-cpan perl-dev build-base
RUN rm -rf /var/cache/apk
ADD http://hexacorn.com/d/DeXRAY.pl /bin/dexray
RUN chmod +rx /bin/dexray




FROM alpine:latest
ARG PUID=1001
ARG PGID=1001

MAINTAINER tabledevil
COPY --from=builder . .
RUN mkdir /data
RUN adduser -D -u 1001 -s "/bin/busybox nologin" nonroot 1001
RUN chown -R nonroot:nonroot /data
USER nonroot
WORKDIR /data/