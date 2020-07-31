FROM ubuntu:latest AS builder
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    perl \
    cpanminus \
 && rm -rf /var/lib/apt/lists/*

RUN cpanm Crypt::RC4
RUN cpanm Digest::CRC
RUN cpanm Crypt::Blowfish
RUN cpanm Archive::Zip
RUN cpanm OLE::Storage_Lite
RUN apt-get remove -y \
    build-essential \
    curl \
    perl \
 && rm -rf /var/lib/apt/lists/*
 ADD http://hexacorn.com/d/DeXRAY.pl /bin/dexray
 RUN chmod +rx /bin/dexray




FROM ubuntu:latest
ARG PUID=1001
ARG PGID=1001

MAINTAINER tabledevil
COPY --from=builder . .

# ADD start.sh /start.sh
# RUN chmod +x /start.sh
RUN groupadd -g ${PGID} -r nonroot && \
    useradd -u ${PUID} -r -g nonroot -d /home/nonroot -s /sbin/nologin -c "Nonroot User" nonroot && \
    mkdir /home/nonroot && \
    chown -R nonroot:nonroot /home/nonroot
# ENTRYPOINT ["/start.sh"]
# CMD ["shell"]
USER nonroot
WORKDIR /data/
