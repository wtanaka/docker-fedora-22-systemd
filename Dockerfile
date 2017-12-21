FROM fedora:22
MAINTAINER http://wtanaka.com/dockerfiles
# systemd likes to know that it is running within a container
ENV container docker

RUN dnf -y update && dnf clean all

# Already installed
# RUN dnf -y install systemd && dnf clean all

RUN (cd /lib/systemd/system/sysinit.target.wants/; \
  for i in *; do \
    [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; \
  done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*; \
  rm -f /etc/systemd/system/*.wants/*; \
  rm -f /lib/systemd/system/local-fs.target.wants/*;  \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*;  \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*;  \
  rm -f /lib/systemd/system/basic.target.wants/*; \
  rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN systemctl mask \
  systemd-remount-fs.service \
  dev-hugepages.mount \
  sys-fs-fuse-connections.mount \
  systemd-logind.service \
  getty.target \
  console-getty.service

RUN cp /usr/lib/systemd/system/dbus.service /etc/systemd/system/; \
  sed -i 's/OOMScoreAdjust=-900//' /etc/systemd/system/dbus.service

# systemd does not exit on sigterm
STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]
#, "/run", "/tmp"]

CMD ["/sbin/init"]
