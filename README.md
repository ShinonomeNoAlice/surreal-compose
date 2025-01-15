# `surreal-compose.yaml`
This repository houses a pre-configured `docker-compose.yaml` as well as relevant directories and config files to have an out-of-the-box SurrealDB instance running on top of a TiKV cluster, with Prometheus and Grafana for monitoring.

Think of it like a distro.

## How to use
```sh
# Modify to taste.
git clone https://github.com/ShinonomeNoAlice/surreal-compose
```
Due to the ubiquitous nature of `docker-compose.yaml` and `config/`, I strongly recommend you to **NOT** blindly `mv surreal-compose/* .` to avoid unfortunate overwrites.

## Differences compared to [upstream](https://github.com/surrealdb/docker.surrealdb.com)
- Data and logs are volume mounts instead of bind mounts for ease of transitioning to multi-machine deployments.
    - This requires a one-shot `volume_instantiation` that is executed first every `docker compose up`.
    - All files are under each machine's hostname directory, i.e., `tikv0`'s files are under `/{name}/tikv/tikv0`.
- `tikv` containers now explicitly `--advertise-addr` and `--advertise-status-addr` for sane connecting.
- Basic `prometheus.yml` for PD and TiKV provided.
    - Blank `*.rules.yml` for convenience.
- Blank Grafana config files and directories (`grafana.ini`, `provisions/*`) provided to make Grafana shut up in the logs.

