#!/usr/bin/env bash
export PATH=$PATH:/usr/local/go/bin:/go/bin
export GOROOT=/usr/local/go
export GOPATH=/go

mkdir /src
cd /src
git clone https://github.com/syncthing/syncthing
cd syncthing
go run build.go
cp /src/syncthing/bin/* /usr/bin/
cp /src/syncthing/etc/linux-systemd/system/syncthing@.service /etc/systemd/system/
mkdir -p /etc/systemd/system/syncthing@.service.d/
cat << EOF > /etc/systemd/system/syncthing@.service.d/override.conf
[Service]
Environment=STGUIADDRESS=0.0.0.0:8384

EOF
cd
rm -rf /src