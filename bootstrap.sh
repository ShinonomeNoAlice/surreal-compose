#!/bin/bash

# Prometheus
echo "Downloading Prometheus alert rules for TiKV..."
curl -sSL https://github.com/tikv/tikv/raw/refs/heads/master/metrics/alertmanager/tikv.rules.yml -o config/prometheus/tikv_alert.rules.yml
echo "Downloading Prometheus alert rules for PD..."
curl -sSL https://github.com/tikv/pd/raw/refs/heads/master/metrics/alertmanager/pd.rules.yml -o config/prometheus/pd_alert.rules.yml

# Grafana
echo "Downloading Grafana dashboards for TiKV..."
curl -sSL https://github.com/tikv/tikv/raw/refs/heads/master/metrics/grafana/tikv_details.json -o config/dashboards/tikv_details.json
echo "Downloading Grafana dashboards for PD..."
curl -sSL https://github.com/tikv/pd/raw/refs/heads/master/metrics/grafana/pd.json -o config/dashboards/pd.json

# Start the entire stack
docker compose --profile monitoring up -d --pull always

# Grafana
echo "Waiting for Grafana to be ready..."
until curl -s http://localhost:3000/api/health | grep '"database": "ok"'; do
  sleep 1
done

echo "Setting up Grafana data sources..."
curl -X POST http://admin:admin@localhost:3000/api/datasources \
     -H "Accept: application/json" \
     -H "Content-Type: application/json" \
     -d '{"name": "Local TiKV Cluster", "type": "prometheus", "url": "http://prometheus:9090", "access": "proxy", "basicAuth": false}'

# Echo out URLs of the services
echo "Everything is up and running! Here are the URLs:"
echo "Promehteus: http://localhost:9090 (No authenticaltion required)"
echo "Grafa: http://localhost:3000 (admin:admin)"
echo "SurrealDB: http://localhost:8000 (root:root)"
