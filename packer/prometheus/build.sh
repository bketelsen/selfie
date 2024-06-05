#!/usr/bin/env bash
useradd -M -U prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
tar -xzvf prometheus-2.52.0.linux-amd64.tar.gz


mv prometheus-2.52.0.linux-amd64 /opt/prometheus/
mkdir -p /opt/prometheus/data
chown prometheus:prometheus -R /opt/prometheus

systemctl enable prometheus
