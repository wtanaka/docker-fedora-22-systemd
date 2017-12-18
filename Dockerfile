FROM fedora:22
MAINTAINER http://wtanaka.com/dockerfiles

RUN dnf -y update && dnf clean all

RUN systemctl mask systemd-remount-fs.service dev-hugepages.mount \
sys-fs-fuse-connections.mount systemd-logind.service getty.target \
console-getty.service
RUN cp /usr/lib/systemd/system/dbus.service /etc/systemd/system/; sed \
-i 's/OOMScoreAdjust=-900//' /etc/systemd/system/dbus.service


VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]
ENV container=docker

CMD ["/usr/sbin/init"]
