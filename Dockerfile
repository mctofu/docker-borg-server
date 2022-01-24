FROM alpine:3.15.0

ARG BORG_UID
# workaround for ARGs not working completely on synology devices
ENV BORG_UID=$BORG_UID

RUN apk add openssh-server borgbackup --no-cache

RUN adduser -D -u $BORG_UID borg && \
    mkdir -p /home/borg/backups && \
    mkdir -p /home/borg/.ssh && \
    mkdir -p /var/run/sshd && \
    /usr/bin/ssh-keygen -A && \
    sed -i \
         -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
         -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
         -e 's/^#ChallengeResponseAuthentication yes$/ChallengeResponseAuthentication no/g' \
         /etc/ssh/sshd_config

RUN passwd -u borg

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
