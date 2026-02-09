# Troubleshooting Guide

Common issues and solutions for the Future Technologies Lab Dashboard.

## Table of Contents
- [Installation Issues](#installation-issues)
- [Connection Problems](#connection-problems)
- [Dashboard Issues](#dashboard-issues)
- [Data Problems](#data-problems)
- [Performance Issues](#performance-issues)

## Installation Issues

### Docker Compose Fails to Start

**Symptom**: `docker-compose up` fails with errors

**Solutions**:

1. **Check Docker is running**
```bash
docker --version
docker-compose --version
systemctl status docker  # Linux
# or
open -a Docker  # macOS
```

2. **Port already in use (3000 or 5432)**
```bash
# Check what's using the port
lsof -i :3000
lsof -i :5432

# Kill the process or change port in docker-compose.yml
ports:
  - "3001:3000"  # Use different external port
```

3. **Permission denied**
```bash
# Linux: Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in

# Or run with sudo
sudo docker-compose up -d
```

4. **Disk space issues**
```bash
# Check disk space
df -h

# Clean up old Docker resources
docker system prune -a
```

### Containers Keep Restarting

**Check logs**:
```bash
docker-compose logs grafana
docker-compose logs postgres
```

**Common causes**:
- Database initialization failed
- Configuration syntax errors
- Missing required files

**Solution**:
```bash
# Remove everything and start fresh
docker-compose down -v
docker-compose up -d
```

## Connection Problems

### Cannot Access Grafana at localhost:3000

**Check container is running**:
```bash
docker-compose ps
# Should show lab-grafana as "Up"
```

**Check container logs**:
```bash
docker-compose logs grafana
```

**Try different browsers**:
- Clear browser cache
- Try incognito/private mode
- Test in different browser

**Firewall issues**:
```bash
# Linux: Check if port is accessible
sudo iptables -L | grep 3000

# macOS: Check firewall settings
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
```

### Grafana Shows "Database Locked" or Connection Errors

**PostgreSQL not ready**:
```bash
# Check PostgreSQL status
docker exec lab-postgres pg_isready -U labuser -d labdb

# Restart containers in order
docker-compose restart postgres
sleep 10
docker-compose restart grafana
```

**Connection refused**:
```bash
# Check if containers are on same network
docker network inspect lab-dashboard_lab-network

# Verify datasource configuration
docker exec lab-grafana cat /etc/grafana/provisioning/datasources/datasource.yml
```

### Cannot Login to Grafana

**Default credentials not working**:
1. Check docker-compose.yml for correct credentials
2. Reset admin password:
```bash
docker exec -it lab-grafana grafana-cli admin reset-admin-password newpassword
```

**Anonymous access issues**:
Check environment variables in docker-compose.yml:
```yaml
- GF_AUTH_ANONYMOUS_ENABLED=true
- GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer
```

## Dashboard Issues

### Dashboard Not Loading / Shows Blank

**Dashboard not provisioned**:
```bash
# Check if dashboard file exists
docker exec lab-grafana ls -la /var/lib/grafana/dashboards/

# Check provisioning config
docker exec lab-grafana cat /etc/grafana/provisioning/dashboards/dashboard.yml
```

**Recreate dashboard**:
1. Copy `/tmp/grafana/dashboards/lab-overview.json` to project
2. Restart Grafana:
```bash
docker-compose restart grafana
```

### Panels Show "No Data"

**Check database connection**:
```bash
# Verify data exists
docker exec -it lab-postgres psql -U labuser -d labdb -c "SELECT COUNT(*) FROM projects;"
```

**Query syntax errors**:
1. Open panel in edit mode
2. Click "Query Inspector"
3. Check for SQL errors

**Time range issues**:
- Data might be outside selected time range
- Change to "Last 30 days" or "All time"

### Dashboard Shows ${DS_LAB_POSTGRESQL} Instead of Data

**Datasource variable not resolved**:

1. Go to Settings → Variables
2. Delete variable if it exists
3. Dashboard settings → JSON Model
4. Find `"${DS_LAB_POSTGRESQL}"` and replace with:
```json
{
  "type": "postgres",
  "uid": "postgres-uid"
}
```

Or recreate the datasource with exact name "Lab PostgreSQL".

### Permissions Error When Saving Dashboard

**User doesn't have edit rights**:
```bash
# Check user role
docker exec -it lab-grafana grafana-cli admin list-users
```

**Fix**: Login as admin and grant editor role

## Data Problems

### Sample Data Not Loading

**Database initialization failed**:
```bash
# Check initialization logs
docker-compose logs postgres | grep "init-db.sql"

# Manually reinitialize
docker-compose down -v  # WARNING: Deletes all data
docker-compose up -d
```

**Check if tables exist**:
```bash
docker exec -it lab-postgres psql -U labuser -d labdb

# List tables
\dt

# Should show: projects, personnel, tasks, metadata
```

**Manual data load**:
```bash
# Copy SQL file to container
docker cp init-db.sql lab-postgres:/tmp/

# Execute
docker exec -it lab-postgres psql -U labuser -d labdb -f /tmp/init-db.sql
```

### Data Not Updating

**Check auto-refresh**:
- Dashboard should refresh every 30s by default
- Click refresh icon to manual refresh

**Verify database changes**:
```bash
docker exec -it lab-postgres psql -U labuser -d labdb
SELECT * FROM projects;
```

**Clear Grafana cache**:
```bash
docker exec lab-grafana rm -rf /var/lib/grafana/cache/*
docker-compose restart grafana
```

### Incorrect Data Showing

**Old cached data**:
1. Edit panel
2. Query options → Max data points
3. Increase value or set to blank

**View issues**:
```bash
# Refresh materialized views if you added any
docker exec -it lab-postgres psql -U labuser -d labdb -c "
REFRESH MATERIALIZED VIEW IF EXISTS your_view_name;
"
```

## Performance Issues

### Dashboard Loads Slowly

**Too many queries**:
- Reduce number of panels
- Increase refresh interval
- Use dashboard variables for filtering

**Optimize queries**:
```sql
-- Add indexes
CREATE INDEX idx_tasks_status_date ON tasks(status, due_date);
CREATE INDEX idx_projects_status ON projects(status);

-- Use views instead of complex joins
```

**Check database performance**:
```bash
# Monitor database
docker stats lab-postgres

# Check slow queries
docker exec -it lab-postgres psql -U labuser -d labdb -c "
SELECT query, calls, total_time, mean_time 
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;
"
```

### High CPU/Memory Usage

**Container resource limits**:
Edit docker-compose.yml:
```yaml
services:
  grafana:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
        reservations:
          memory: 256M
```

**PostgreSQL tuning**:
```yaml
postgres:
  environment:
    - POSTGRES_SHARED_BUFFERS=256MB
    - POSTGRES_MAX_CONNECTIONS=50
```

### Containers Crash or Restart

**Out of memory**:
```bash
# Check logs
docker-compose logs --tail=100

# Increase memory limit
# Edit docker-compose.yml as shown above
```

**Database corruption**:
```bash
# Backup first!
docker exec lab-postgres pg_dump -U labuser labdb > backup.sql

# Check database
docker exec lab-postgres pg_checksums -D /var/lib/postgresql/data

# If corrupted, restore from backup
docker-compose down -v
docker-compose up -d
cat backup.sql | docker exec -i lab-postgres psql -U labuser -d labdb
```

## Common Error Messages

### "pq: password authentication failed"
- Wrong credentials in datasource.yml
- Check docker-compose.yml POSTGRES_PASSWORD matches datasource password

### "dial tcp: lookup postgres: no such host"
- Containers not on same network
- Recreate: `docker-compose down && docker-compose up -d`

### "dashboard not found"
- Dashboard JSON not properly provisioned
- Check file exists in `/tmp/grafana/dashboards/`
- Verify dashboard.yml configuration

### "plugin not found"
- Plugin installation failed
- Check: `docker exec lab-grafana grafana-cli plugins ls`
- Reinstall: 
```bash
docker exec lab-grafana grafana-cli plugins install marcusolsson-json-datasource
docker-compose restart grafana
```

## Getting Help

If issues persist:

1. **Collect information**:
```bash
docker-compose ps
docker-compose logs > logs.txt
docker version
```

2. **Check documentation**:
- Grafana: https://grafana.com/docs/
- PostgreSQL: https://www.postgresql.org/docs/
- Docker: https://docs.docker.com/

3. **Create GitHub issue** with:
- Problem description
- Error messages
- Log files
- Docker version
- Operating system

## Reset Everything

When all else fails, complete reset:

```bash
# Stop and remove everything
docker-compose down -v

# Remove Docker images (optional)
docker rmi grafana/grafana:latest postgres:15-alpine

# Remove local files (be careful!)
# rm -rf grafana/dashboards/*  # Don't delete source files

# Start fresh
docker-compose up -d

# Check status
docker-compose ps
docker-compose logs -f
```

## Prevention

**Best practices to avoid issues**:

1. Regular backups:
```bash
# Schedule this with cron
docker exec lab-postgres pg_dump -U labuser labdb | gzip > backup_$(date +%Y%m%d).sql.gz
```

2. Monitor disk space:
```bash
docker system df
```

3. Keep Docker updated:
```bash
docker version
# Update via your package manager
```

4. Version control your configs:
```bash
git add docker-compose.yml grafana/ init-db.sql
git commit -m "Update configuration"
```

5. Test changes in development first
