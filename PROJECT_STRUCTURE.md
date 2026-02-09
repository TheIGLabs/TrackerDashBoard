# Project Structure

```
lab-dashboard/
│
├── README.md                          # Main documentation and getting started guide
├── LICENSE                            # MIT License
├── .gitignore                        # Git ignore rules
├── docker-compose.yml                # Docker services configuration
├── init-db.sql                       # PostgreSQL schema and sample data
├── setup.sh                          # Quick setup script (optional)
├── GITHUB_SETUP.md                   # Instructions for uploading to GitHub
│
├── docs/                             # Additional documentation
│   ├── CUSTOMIZATION.md              # Guide for customizing dashboards
│   └── TROUBLESHOOTING.md            # Common issues and solutions
│
└── grafana/                          # Grafana configuration
    ├── provisioning/                 # Auto-provisioning configs
    │   ├── datasources/              # Database connections
    │   │   └── datasource.yml        # PostgreSQL datasource config
    │   └── dashboards/               # Dashboard providers
    │       └── dashboard.yml         # Dashboard provisioning config
    └── dashboards/                   # Dashboard definitions
        └── lab-overview.json         # Main lab dashboard
```

## File Descriptions

### Root Directory

**README.md**
- Main project documentation
- Quick start guide
- Feature overview
- Installation instructions
- Usage examples
- Management commands

**LICENSE**
- MIT License for open source distribution

**.gitignore**
- Excludes temporary files, logs, secrets, and Docker volumes from Git

**docker-compose.yml**
- Defines two services: Grafana and PostgreSQL
- Configures networking, volumes, and environment variables
- Sets up automatic restart policies
- Enables anonymous viewing for visitors

**init-db.sql**
- Creates database schema (projects, personnel, tasks tables)
- Inserts sample data for demonstration
- Creates useful views for common queries
- Sets up indexes for performance
- Includes metadata tracking

**setup.sh**
- Automated setup script (optional)
- Checks prerequisites (Docker, Docker Compose)
- Verifies ports availability
- Starts services
- Provides helpful next steps

**GITHUB_SETUP.md**
- Step-by-step GitHub upload instructions
- Multiple methods (web, CLI, GitHub CLI)
- Best practices for repository management
- Collaboration setup guide

### docs/ Directory

**CUSTOMIZATION.md**
- How to modify sample data
- Adding new dashboard panels
- Changing visualizations
- Theming options
- Setting up alerts
- Creating variables
- Export/import instructions

**TROUBLESHOOTING.md**
- Common installation issues
- Connection problems
- Dashboard loading issues
- Data synchronization problems
- Performance optimization
- Error message reference
- Recovery procedures

### grafana/ Directory

**grafana/provisioning/datasources/datasource.yml**
- Auto-configures PostgreSQL connection
- Sets up default datasource
- Configures connection parameters
- No manual configuration needed

**grafana/provisioning/dashboards/dashboard.yml**
- Tells Grafana where to find dashboards
- Enables automatic dashboard loading
- Allows UI updates
- Sets refresh interval

**grafana/dashboards/lab-overview.json**
- Main dashboard definition (JSON format)
- Contains 11 panels:
  1. Active Projects (stat)
  2. Team Utilization (gauge)
  3. Total Personnel (stat)
  4. Active Tasks (stat)
  5. Projects by Priority (bar gauge)
  6. Project Status Distribution (pie chart)
  7. Task Status Distribution (donut chart)
  8. Personnel Utilization (bar gauge)
  9. Project Overview (table)
  10. Upcoming Tasks (table)
  11. Personnel Workload Details (table)
- Configured for 30-second auto-refresh
- Uses dark theme by default
- Mobile-responsive layout

## Data Flow

```
User Request
    ↓
Grafana Dashboard (Port 3000)
    ↓
SQL Queries
    ↓
PostgreSQL Database (Port 5432)
    ↓
Tables: projects, personnel, tasks
    ↓
Views: project_summary, utilization_summary, etc.
    ↓
Data Returned to Dashboard
    ↓
Visualizations Rendered
```

## Volume Mounts

Docker creates persistent volumes for data:
- `grafana-data`: Stores Grafana configuration and plugins
- `postgres-data`: Stores PostgreSQL database files

Local directories mounted into containers:
- `./grafana/provisioning` → `/etc/grafana/provisioning`
- `./grafana/dashboards` → `/var/lib/grafana/dashboards`
- `./init-db.sql` → `/docker-entrypoint-initdb.d/init-db.sql`

## Network

- Both containers connect to `lab-network` bridge network
- Containers can communicate using service names (grafana, postgres)
- Only Grafana port (3000) is exposed to host
- PostgreSQL (5432) is internal only for security

## Environment Variables

### Grafana
- `GF_SECURITY_ADMIN_USER`: Admin username (default: admin)
- `GF_SECURITY_ADMIN_PASSWORD`: Admin password (default: admin)
- `GF_AUTH_ANONYMOUS_ENABLED`: Allow viewing without login (true)
- `GF_AUTH_ANONYMOUS_ORG_ROLE`: Role for anonymous users (Viewer)

### PostgreSQL
- `POSTGRES_USER`: Database user (labuser)
- `POSTGRES_PASSWORD`: Database password (labpass)
- `POSTGRES_DB`: Database name (labdb)

## Important Notes

1. **Security**: Default passwords should be changed for production
2. **Persistence**: Docker volumes ensure data survives container restarts
3. **Auto-provisioning**: Dashboards and datasources load automatically
4. **Anonymous Access**: Enabled for visitor viewing
5. **Sample Data**: Pre-loaded for immediate demonstration
6. **Customization**: All configuration files are editable
7. **Scalability**: Can connect to external PostgreSQL if needed

## Maintenance Files

Consider adding (not included):
- `.env` file for environment-specific variables
- `docker-compose.prod.yml` for production overrides
- `scripts/` directory for data update scripts
- `backups/` directory for database backups
- `screenshots/` directory for documentation images

## Size Information

Approximate sizes:
- Docker images: ~500MB total (Grafana + PostgreSQL)
- Sample database: <1MB
- Configuration files: <100KB
- Dashboard JSON: ~50KB

## Dependencies

External services:
- Docker Engine 20.10+
- Docker Compose 2.0+

Container images:
- `grafana/grafana:latest`
- `postgres:15-alpine`

Optional plugins:
- `marcusolsson-json-datasource` (auto-installed)
