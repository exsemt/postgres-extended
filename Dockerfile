FROM postgres:17.4 AS env-build

# Install build dependencies
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  git \
  postgresql-server-dev-17 \
  && rm -rf /var/lib/apt/lists/*

# Clone and build pg_uuidv7
RUN git clone --depth 1 https://github.com/fboulnois/pg_uuidv7.git /build && \
  cd /build && \
  make && \
  make install

# Final image
FROM postgres:17.4

# Copy extension files from builder
COPY --from=env-build /usr/lib/postgresql/17/lib/pg_uuidv7.so /usr/lib/postgresql/17/lib/
COPY --from=env-build /usr/share/postgresql/17/extension/pg_uuidv7.control /usr/share/postgresql/17/extension/
COPY --from=env-build /usr/share/postgresql/17/extension/pg_uuidv7--*.sql /usr/share/postgresql/17/extension/

# Enable extension
RUN echo "shared_preload_libraries = 'pg_uuidv7'" >> /usr/share/postgresql/postgresql.conf.sample

# Create init script
RUN echo "CREATE EXTENSION IF NOT EXISTS pg_uuidv7;" > /docker-entrypoint-initdb.d/10-pg_uuidv7.sql

EXPOSE 5432
