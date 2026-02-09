# Quick Reference Card

## 🚀 Quick Start
```bash
docker-compose up -d
```
Access: http://localhost:3000 (admin/admin)

## 📂 File Overview
| File | Purpose |
|------|---------|
| `docker-compose.yml` | Service configuration |
| `init-db.sql` | Database schema + sample data |
| `README.md` | Main documentation |
| `GITHUB_SETUP.md` | Upload to GitHub instructions |
| `setup.sh` | Automated setup script |

## 🎯 Essential Commands

### Start/Stop
```bash
docker-compose up -d          # Start services
docker-compose stop           # Stop services
docker-compose restart        # Restart services
docker-compose down           # Stop and remove containers
docker-compose down -v        # Stop and remove everything (INCLUDING DATA!)
```

### Monitoring
```bash
docker-compose ps             # Check status
docker-compose logs -f        # View live logs
docker-compose logs grafana   # View Grafana logs only
docker stats                  # Monitor resource usage
```

### Database Access
```bash
# Connect to PostgreSQL
docker exec -it lab-postgres psql -U labuser -d labdb

# Inside PostgreSQL:
\dt                           # List tables
SELECT * FROM projects;       # Query data
\q                            # Exit
```

### Data Management
```bash
# Backup database
docker exec lab-postgres pg_dump -U labuser labdb > backup.sql

# Restore database
cat backup.sql | docker exec -i lab-postgres psql -U labuser -d labdb

# Reset to fresh data
docker-compose down -v
docker-compose up -d
```

## 🔧 Common Modifications

### Change Admin Password
Edit `docker-compose.yml`:
```yaml
- GF_SECURITY_ADMIN_PASSWORD=YourNewPassword
```

### Change Port
Edit `docker-compose.yml`:
```yaml
ports:
  - "8080:3000"  # Access on port 8080 instead
```

### Disable Anonymous Access
Edit `docker-compose.yml`:
```yaml
- GF_AUTH_ANONYMOUS_ENABLED=false
```

### Add Your Own Data
Edit `init-db.sql` and add:
```sql
INSERT INTO projects (name, status, priority, start_date, end_date, completion_percentage)
VALUES ('My Project', 'In Progress', 'High', '2026-03-01', '2026-09-30', 25);
```

## 📊 Dashboard URLs

| Dashboard | URL |
|-----------|-----|
| Home | http://localhost:3000 |
| Lab Overview | http://localhost:3000/d/lab-overview |
| Data Source Settings | http://localhost:3000/datasources |
| Dashboard Settings | http://localhost:3000/dashboards |

## 🗄️ Database Schema

### Tables
- **projects**: Lab projects and their status
- **personnel**: Team members and utilization
- **tasks**: Individual tasks and assignments

### Views
- **project_summary**: Aggregated project data
- **utilization_summary**: Team utilization stats
- **task_status_summary**: Task distribution
- **personnel_workload**: Individual workloads

## 🆘 Troubleshooting Quick Fixes

| Problem | Solution |
|---------|----------|
| Port 3000 in use | Change port in docker-compose.yml |
| Can't access dashboard | Check `docker-compose ps`, restart if needed |
| No data showing | Check database: `docker exec -it lab-postgres psql -U labuser -d labdb -c "SELECT COUNT(*) FROM projects;"` |
| Dashboard not loading | Delete browser cache, try incognito mode |
| Containers keep restarting | Check logs: `docker-compose logs` |

## 📁 GitHub Upload Steps

1. Create repo on GitHub (don't initialize with README)
2. In your local project folder:
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/lab-dashboard.git
git push -u origin main
```

## 🔐 Security Checklist for Production

- [ ] Change default admin password
- [ ] Change database password
- [ ] Use environment variables for secrets
- [ ] Consider disabling anonymous access
- [ ] Set up HTTPS/TLS
- [ ] Configure firewall rules
- [ ] Regular backups
- [ ] Update Docker images regularly

## 📚 Documentation Files

| File | Content |
|------|---------|
| `README.md` | Getting started, features, installation |
| `GITHUB_SETUP.md` | How to upload to GitHub |
| `PROJECT_STRUCTURE.md` | Detailed file structure explanation |
| `docs/CUSTOMIZATION.md` | How to customize dashboards |
| `docs/TROUBLESHOOTING.md` | Common issues and solutions |

## 🌟 Key Features

✅ Real-time project tracking
✅ Personnel utilization monitoring
✅ Task management visualization
✅ Anonymous visitor viewing
✅ Auto-refreshing dashboards (30s)
✅ Docker-based (easy deployment)
✅ Sample data included
✅ Mobile responsive
✅ No manual configuration needed

## 📞 Getting Help

1. Check `docs/TROUBLESHOOTING.md`
2. Review logs: `docker-compose logs`
3. Test database connection
4. Verify all files are present
5. Create GitHub issue with logs and error details

---
**Version**: 1.0.0 | **Last Updated**: February 2026
