# postgres-extended
Postgres with pg_uuidv7 extension.

## Dev

build local

```sh
# Build
docker buildx build --platform linux/arm64 -t postgres-extended:test .

# Test
docker run -d \
  --name postgres-test \
  -e POSTGRES_PASSWORD=test123 \
  -p 5432:5432 \
  postgres-extended:test
```
