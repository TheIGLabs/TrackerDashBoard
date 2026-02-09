# Customization Guide

This guide explains how to customize the Future Technologies Lab Dashboard to fit your specific needs.

## Table of Contents
- [Customizing Data](#customizing-data)
- [Adding New Panels](#adding-new-panels)
- [Modifying Visualizations](#modifying-visualizations)
- [Theming](#theming)
- [Adding Alerts](#adding-alerts)

## Customizing Data

### Method 1: Modify Sample Data
Edit `init-db.sql` to change the sample data that loads on first startup.

```sql
-- Add your own projects
INSERT INTO projects (name, status, priority, start_date, end_date, completion_percentage, description) 
VALUES 
('Your Project Name', 'In Progress', 'High', '2026-03-01', '2026-09-30', 25, 'Project description');

-- Add your personnel
INSERT INTO personnel (name, role, utilization_percentage, current_project_id, email, skills) 
VALUES 
('Jane Doe', 'Researcher', 75, 1, 'jane@lab.com', ARRAY['ML', 'Python']);
```

After editing, recreate the database:
```bash
docker-compose down -v
docker-compose up -d
```

### Method 2: Direct Database Updates
Connect to the running database and update data in real-time:

```bash
# Connect to PostgreSQL
docker exec -it lab-postgres psql -U labuser -d labdb

# Update a project
UPDATE projects SET completion_percentage = 65 WHERE name = 'Quantum Computing Research';

# Add a new task
INSERT INTO tasks (title, project_id, assigned_to, status, priority, due_date, estimated_hours) 
VALUES ('New Task', 1, 1, 'In Progress', 'High', '2026-03-15', 40);
```

### Method 3: API Integration
Create a script to populate data from your existing systems:

```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="labdb",
    user="labuser",
    password="labpass"
)

cur = conn.cursor()
cur.execute("""
    INSERT INTO projects (name, status, priority, start_date, end_date, completion_percentage)
    VALUES (%s, %s, %s, %s, %s, %s)
""", ("New Project", "Planning", "Medium", "2026-03-01", "2026-08-31", 5))

conn.commit()
cur.close()
conn.close()
```

## Adding New Panels

### Step 1: Access Grafana
1. Navigate to http://localhost:3000
2. Login with admin/admin
3. Go to Dashboards → Future Technologies Lab - Overview
4. Click "Add" → "Visualization"

### Step 2: Configure Data Source
1. Select "Lab PostgreSQL" as the data source
2. Switch to "Code" mode
3. Write your SQL query

### Step 3: Choose Visualization Type
Common panel types:
- **Stat**: Single value metrics
- **Gauge**: Progress indicators
- **Bar Gauge**: Multiple values comparison
- **Time Series**: Trends over time
- **Table**: Detailed data view
- **Pie Chart**: Distribution visualization

### Example: Adding a "High Priority Tasks" Panel

```sql
SELECT 
    COUNT(*) as "High Priority Tasks"
FROM tasks 
WHERE priority = 'High' 
AND status IN ('In Progress', 'Planning');
```

1. Choose "Stat" visualization
2. Set color thresholds
3. Position and size the panel
4. Save the dashboard

## Modifying Visualizations

### Changing Colors
1. Edit panel → Field tab
2. Under "Thresholds", modify values and colors
3. Common patterns:
   - Green (0-70): Good
   - Yellow (70-90): Warning
   - Red (90-100): Critical

### Custom Field Mappings
Transform data values into custom displays:

1. Edit panel → Overrides
2. Add override by field name
3. Set custom mappings

Example - Status colors:
```json
{
  "type": "value",
  "options": {
    "In Progress": { "color": "blue" },
    "Completed": { "color": "green" },
    "On Hold": { "color": "orange" }
  }
}
```

### Table Customization
Enhance table panels with:
- **Column width**: Auto, fixed, or min/max
- **Cell display modes**: Auto, color background, gradient gauge, JSON view
- **Sorting**: Set default sort column and direction

Example table override for completion percentage:
```json
{
  "matcher": { "id": "byName", "options": "Completion" },
  "properties": [
    { "id": "unit", "value": "percent" },
    { "id": "custom.cellOptions", "value": { "type": "gauge", "mode": "gradient" }},
    { "id": "max", "value": 100 }
  ]
}
```

## Theming

### Dashboard Theme
Change the overall theme:
1. Edit dashboard settings (gear icon)
2. Settings → General → Theme
3. Choose: Dark, Light, or Default

### Custom Panel Styles
Use Grafana's styling options:
- Panel title color
- Background transparency
- Border style

### Logo and Branding
Add your lab logo:
1. Edit `docker-compose.yml`
2. Add environment variable:
```yaml
- GF_SERVER_ROOT_URL=http://localhost:3000
- GF_SERVER_SERVE_FROM_SUB_PATH=false
```

3. Upload logo via Grafana UI:
   - Configuration → Preferences → Branding

## Adding Alerts

### Configure Email Notifications
1. Edit `docker-compose.yml`:
```yaml
environment:
  - GF_SMTP_ENABLED=true
  - GF_SMTP_HOST=smtp.gmail.com:587
  - GF_SMTP_USER=your-email@gmail.com
  - GF_SMTP_PASSWORD=your-app-password
  - GF_SMTP_FROM_ADDRESS=your-email@gmail.com
```

2. Restart Grafana:
```bash
docker-compose restart grafana
```

### Create Alert Rules
1. Edit a panel
2. Go to Alert tab
3. Create new alert rule

Example: Alert when team utilization exceeds 90%
```
Condition: WHEN avg() OF query(A, 5m, now) IS ABOVE 90
```

### Alert Channels
Set up notification channels:
1. Alerting → Notification channels
2. Add channel (Email, Slack, PagerDuty, etc.)
3. Test notification

## Advanced Customization

### Variables
Create dashboard variables for filtering:
1. Dashboard settings → Variables → Add variable
2. Query example:
```sql
SELECT DISTINCT status FROM projects ORDER BY status
```

3. Use in panels: `WHERE status = '$status'`

### Custom Time Ranges
Add time range selector:
1. Dashboard settings → Time options
2. Set refresh interval (30s default)
3. Configure relative time options

### Panel Links
Add clickable links to panels:
1. Edit panel → Panel options → Links
2. Add dashboard link, URL, or data link

### Annotations
Mark events on time series:
1. Dashboard settings → Annotations
2. Add annotation query:
```sql
SELECT 
    created_at as time,
    name as text,
    'Project Created' as tags
FROM projects
WHERE created_at > $__timeFrom()
```

## Best Practices

1. **Performance**: Keep queries efficient, use indexes
2. **Refresh Rate**: Balance between real-time and server load
3. **Layout**: Group related panels, use consistent sizing
4. **Colors**: Maintain consistent color scheme across panels
5. **Documentation**: Add panel descriptions for context

## Exporting and Sharing

### Export Dashboard
1. Dashboard settings → JSON Model
2. Copy JSON or download file
3. Share with other Grafana instances

### Snapshot
Create a snapshot for sharing:
1. Share dashboard icon
2. Snapshot → Publish
3. Set expiration time

## Troubleshooting

**Panel shows "No Data"**
- Check SQL syntax
- Verify data exists in database
- Check time range settings

**Slow loading panels**
- Optimize SQL queries
- Add database indexes
- Reduce refresh frequency

**Changes not saving**
- Ensure you have edit permissions
- Check for browser console errors
- Try incognito mode to rule out cache issues

## Resources

- [Grafana Documentation](https://grafana.com/docs/)
- [PostgreSQL Query Guide](https://www.postgresql.org/docs/)
- [Dashboard Examples](https://grafana.com/grafana/dashboards/)
