#!/bin/bash
set -e

# init-schema.sh
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE SCHEMA IF NOT EXISTS "$POSTGRES_SCHEMA";
    ALTER DATABASE "$POSTGRES_DB" SET search_path TO "$POSTGRES_SCHEMA", public;
EOSQL