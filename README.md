# Grafana Weather Dashboard (local k8)

Public documentation repo for the local Kubernetes Grafana weather dashboard.

## Dashboard
- Title: Weather Overview (local k8)
- UID: `a6rjt2`
- Current version (captured): `20`
- URL: http://192.168.0.28:3000/d/a6rjt2/weather-overview-local-k8

## Data source
- Grafana datasource UID: `influxdb3-crypto`
- InfluxDB database: `weather`
- Measurement: `weather_observations`

## What this dashboard includes
- 4 KPI stat cards (6h trend, data-driven thresholds):
  - Temperature
  - Humidity
  - Wind Speed
  - Barometric Pressure
- 3 timeseries panels:
  - Temperature (°C)
  - Relative Humidity (%)
  - Wind Speed (km/h)
- 1 table panel:
  - Latest by Station (includes `last_seen` datetime)

## Station coverage
Current stations represented in panel overrides:

- `KATL`
- `KBOI`
- `KBOS`
- `KDEN`
- `KDFW`
- `KJFK`
- `KLAX`
- `KMIA`
- `KORD`
- `KPHX`
- `KSEA`

Includes Boise coverage via `KBOI`.

## UX/styling highlights
- Line-only charts (dots disabled)
- Smooth interpolation
- Consistent station color mapping across all timeseries panels
- Right-side sorted legend with fixed width for readability
- Shared quick-focus links in dashboard header
- Dark-theme-friendly palette

## Known pitfall addressed
InfluxQL `last()` grouped table results can expose a synthetic epoch `Time` (1969/1970 rendering). This dashboard avoids that by explicitly selecting `last(time) AS last_seen` and organizing table columns to hide raw synthetic time.

## Screenshots
- Overview:
  - `screenshots/dashboard-overview.png`
- Boise focus view:
  - `screenshots/dashboard-focus-kboi.png`

## One-click import into Grafana
Use Grafana HTTP API to import this dashboard JSON in one command.

Prerequisites:
- Grafana URL (example: `http://localhost:3000`)
- API key with dashboard write permissions, or admin basic auth

### Option A: API key (recommended)
```bash
curl -sS -X POST "$GRAFANA_URL/api/dashboards/db" \
  -H "Authorization: Bearer $GRAFANA_API_KEY" \
  -H "Content-Type: application/json" \
  -d @<(jq -n --slurpfile d dashboard/weather-overview-local-k8.dashboard.json '{dashboard:$d[0], folderId:0, overwrite:true}')
```

### Option B: basic auth
```bash
curl -sS -X POST "$GRAFANA_URL/api/dashboards/db" \
  -u "$GRAFANA_USER:$GRAFANA_PASS" \
  -H "Content-Type: application/json" \
  -d @<(jq -n --slurpfile d dashboard/weather-overview-local-k8.dashboard.json '{dashboard:$d[0], folderId:0, overwrite:true}')
```

### Helper script
```bash
./scripts/import-dashboard.sh
```

Environment variables supported by the script:
- `GRAFANA_URL` (default: `http://localhost:3000`)
- `GRAFANA_API_KEY` (preferred)
- or `GRAFANA_USER` and `GRAFANA_PASS`

## Repo contents
- `dashboard/weather-overview-local-k8.dashboard.json`
  - Live dashboard export suitable for inspection/import
- `dashboard/summary.json`
  - Compact machine-readable metadata summary
- `screenshots/dashboard-overview.png`
  - Full dashboard screenshot
- `screenshots/dashboard-focus-kboi.png`
  - Station-focused screenshot (KBOI)
- `scripts/import-dashboard.sh`
  - One-command Grafana import helper

## Refreshing this repo from live Grafana
1. Fetch dashboard JSON from Grafana API endpoint:
   - `GET /api/dashboards/uid/a6rjt2`
2. Update `dashboard/weather-overview-local-k8.dashboard.json`
3. Refresh screenshots in `screenshots/`
4. Regenerate `dashboard/summary.json`
5. Commit and push

## Notes
- This repo documents dashboard structure and presentation.
- It does not contain Grafana admin credentials or secrets.
