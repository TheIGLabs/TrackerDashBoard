# Future Technologies Lab Dashboard

A comprehensive Grafana-based dashboard for visualizing lab projects, tasks, personnel assignments, priorities, and team utilization. Perfect for displaying real-time lab activity to visitors and stakeholders.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Docker](https://img.shields.io/badge/docker-compose-blue.svg)

## 🚀 Features

- **Project Tracking**: Visual overview of all active, planned, and completed projects
- **Task Management**: Real-time task status and assignments
- **Personnel Utilization**: Team workload and capacity visualization
- **Priority Dashboard**: At-a-glance view of high-priority items
- **Anonymous Viewing**: Visitors can view dashboards without authentication
- **Docker-based**: Easy deployment with Docker Compose

## 📋 Prerequisites

- Docker Engine (20.10+)
- Docker Compose (2.0+)
- 2GB RAM minimum
- Port 3000 available

## 🔧 Quick Start

1. **Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/lab-dashboard.git
cd lab-dashboard
```

2. **Start the services**
```bash
docker-compose up -d
```

3. **Access Grafana**
- URL: http://localhost:3000
- Default admin credentials:
  - Username: `admin`
  - Password: `admin`
- Visitor access: Enabled by default (no login required)

4. **View the dashboard**
The main dashboard will be automatically provisioned and available at:
http://localhost:3000/d/lab-overview/future-technologies-lab-overview

## 📊 Dashboard Components

### Main Panels
- **Active Projects**: Count of currently in-progress projects
- **Team Utilization**: Average team capacity usage (gauge)
- **Project Status**: Distribution pie chart
- **Projects by Priority**: Sortable table view
- **Personnel Utilization**: Individual team member workload
- **Upcoming Tasks**: Next 10 tasks by due date

## 🗄️ Data Management

### Sample Data
The system comes pre-loaded with sample projects, personnel, and tasks. This data is defined in `init-db.sql`.

### Updating Data

**Option 1: Direct Database Access**
```bash
docker exec -it lab-postgres psql -U labuser -d labdb

-- Example: Add a new project
INSERT INTO projects (name, status, priority, start_date, end_date, completion_percentage) 
VALUES ('New Project', 'Planning', 'High', '2026-03-01', '2026-09-30', 5);
```

**Option 2: Recreate Database**
1. Edit `init-db.sql` with your data
2. Restart with fresh database:
```bash
docker-compose down -v
docker-compose up -d
```

**Option 3: Build Your Own Data Pipeline**
Connect your existing systems to PostgreSQL to automatically populate the database.

## 🏗️ Architecture

```
┌─────────────────┐
│   Grafana       │  Port 3000
│   Dashboard     │  (Visualization)
└────────┬────────┘
         │
         │ SQL Queries
         │
┌────────▼────────┐
│   PostgreSQL    │  Port 5432
│   Database      │  (Data Storage)
└─────────────────┘
```

## 📁 Project Structure

```
lab-dashboard/
├── docker-compose.yml          # Docker services configuration
├── init-db.sql                 # Database schema and sample data
├── .gitignore                  # Git ignore file
├── README.md                   # This file
├── LICENSE                     # MIT License
├── docs/
│   ├── CUSTOMIZATION.md        # Customization guide
│   └── TROUBLESHOOTING.md      # Common issues and solutions
└── grafana/
    ├── provisioning/
    │   ├── datasources/
    │   │   └── datasource.yml  # PostgreSQL connection config
    │   └── dashboards/
    │       └── dashboard.yml   # Dashboard provider config
    └── dashboards/
        └── lab-overview.json   # Main dashboard definition
```

## ⚙️ Configuration

### Grafana Settings
Edit `docker-compose.yml` to customize:
- Admin credentials (`GF_SECURITY_ADMIN_USER`, `GF_SECURITY_ADMIN_PASSWORD`)
- Anonymous access (`GF_AUTH_ANONYMOUS_ENABLED`)
- Port mapping

### Database Settings
PostgreSQL credentials in `docker-compose.yml`:
- User: `labuser`
- Password: `labpass`
- Database: `labdb`

## 🔒 Security Considerations

**For Production Deployment:**
1. Change default admin password
2. Use strong database credentials
3. Consider disabling anonymous access
4. Use environment variables for secrets
5. Enable HTTPS/TLS
6. Restrict network access

Example `.env` file approach:
```bash
# Create .env file
GRAFANA_ADMIN_PASSWORD=your_secure_password
POSTGRES_PASSWORD=your_db_password
```

Update `docker-compose.yml` to use:
```yaml
environment:
  - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}
```

## 🛠️ Management Commands

### View logs
```bash
docker-compose logs -f grafana
docker-compose logs -f postgres
```

### Stop services
```bash
docker-compose stop
```

### Restart services
```bash
docker-compose restart
```

### Remove everything (including data)
```bash
docker-compose down -v
```

### Backup database
```bash
docker exec lab-postgres pg_dump -U labuser labdb > backup.sql
```

### Restore database
```bash
cat backup.sql | docker exec -i lab-postgres psql -U labuser -d labdb
```

## 📈 Customization

See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for:
- Adding new panels
- Creating custom queries
- Modifying visualizations
- Adding alerts
- Theming options

## 🐛 Troubleshooting

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for common issues.

**Quick Checks:**
- Ensure Docker is running: `docker ps`
- Check container status: `docker-compose ps`
- Verify ports are available: `lsof -i :3000`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Grafana](https://grafana.com/)
- Powered by [PostgreSQL](https://www.postgresql.org/)
- Containerized with [Docker](https://www.docker.com/)

## 📞 Support

For issues and questions:
- Open an issue on GitHub
- Check the documentation in `/docs`

---

**Made for Future Technologies Lab** 🔬🚀
