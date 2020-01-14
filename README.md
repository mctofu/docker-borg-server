# docker-borg-server

[BorgBackup](https://borgbackup.readthedocs.io/en/stable/) in a docker container for remote ssh access. This can be useful for running Borg on a NAS.

Borg and ssh are hosted in the docker container. Credentials and storage for backups are mounted as an external volume.

## Building

The uid of the user Borg should use when accessing files needs to be specified. This should match a uid on the host system which has access to the backup data volume.

```
docker build -t borgbackup --build-arg BORG_UID=xxxx .
```

## Running

Two volumes should be mounted to the container:

* `/home/borg/backups` - Stores backed up data. Needs read/write access by the BORG_UID user.
* `/home/borg/.ssh` - Should contain an `authorized_keys` file that defines ssh keys that will be allowed to connect. Needs read access by the BORG_UID user.

```
docker run --rm --name borgbackup -v /volume1/borgbackup/backups:/home/borg/backups -v /volume1/borgbackup/ssh_keys:/home/borg/.ssh -p 2222:22 borgbackup
```

## Using

```
export BORG_RSH="ssh -i <path to ssh key>"
export BORG_REPO=ssh://borg@<docker host ip>:2222/~/backups/<repo name>

# first time
borg init -e <encryption setup>

# create a backup
borg create ::'{hostname}-{now}' /home

```