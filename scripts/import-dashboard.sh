#!/usr/bin/env bash
set -euo pipefail

GRAFANA_URL="${GRAFANA_URL:-http://localhost:3000}"
DASHBOARD_JSON="dashboard/weather-overview-local-k8.dashboard.json"

if [[ ! -f "$DASHBOARD_JSON" ]]; then
  echo "ERROR: $DASHBOARD_JSON not found. Run from repo root."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required"
  exit 1
fi

PAYLOAD=$(jq -n --slurpfile d "$DASHBOARD_JSON" '{dashboard:$d[0], folderId:0, overwrite:true}')

if [[ -n "${GRAFANA_API_KEY:-}" ]]; then
  RESP=$(curl -sS -X POST "$GRAFANA_URL/api/dashboards/db" \
    -H "Authorization: Bearer $GRAFANA_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")
elif [[ -n "${GRAFANA_USER:-}" && -n "${GRAFANA_PASS:-}" ]]; then
  RESP=$(curl -sS -X POST "$GRAFANA_URL/api/dashboards/db" \
    -u "$GRAFANA_USER:$GRAFANA_PASS" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")
else
  echo "ERROR: Set GRAFANA_API_KEY or GRAFANA_USER/GRAFANA_PASS"
  exit 1
fi

echo "$RESP" | jq .
