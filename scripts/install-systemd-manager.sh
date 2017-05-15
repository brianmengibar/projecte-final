#! /bin/bash
# Nom: Brian Mengibar Garcia
# Curs: hisx2
# Sinopsys: Script per instal·lar "systemd-manager"
#--------------------------------------------------

#Ens baixem un paquet exclusiu per Fedora 24
wget https://copr.fedorainfracloud.org/coprs/nunodias/systemd-manager/repo/fedora-24/nunodias-systemd-manager-fedora-24.repo -O /etc/yum.repos.d/nunodias-systemd-manager-fedora-24.repo

# Instal·lem el paquet
dnf install systemd-manager
exit 0
