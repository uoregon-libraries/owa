# OWA Container

This project aims to set up a useful OWA service for UO.

## Setup

You have to copy `docker-compose.override.yml-example` to
`docker-compose.override.yml` and alter it as needed; this is where you specify
on which port OWA is listening.

You also have to copy `env-example` to `.env` in order to set up the OWA
database password.

If for some reason you override the db name or user in the `db` container, make
sure you apply the same override(s) to the `web` container.
