FROM postgres:17.4

# Install build dependencies & remove APT cache
RUN apt-get update && apt-get install -y \
  build-essential \
  postgresql-server-dev-all \
  git \
  && rm -rf /var/lib/apt/lists/*

# Build, install, and clean up pg_uuidv7 in one step
RUN git clone https://github.com/fboulnois/pg_uuidv7.git /pg_uuidv7 \
  && cd /pg_uuidv7 \
  && make \
  && make install \
  && rm -rf /pg_uuidv7

# Add extension to PostgreSQL configuration
RUN echo "shared_preload_libraries = 'pg_uuidv7'" >> /usr/share/postgresql/postgresql.conf.sample

# Create init script to enable the extension
RUN mkdir -p /docker-entrypoint-initdb.d && echo "CREATE EXTENSION IF NOT EXISTS pg_uuidv7;" > /docker-entrypoint-initdb.d/init-uuid.sql

CMD ["postgres"]
