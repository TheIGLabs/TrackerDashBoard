# GitHub Repository Setup Instructions

Follow these steps to import this project to your GitHub account.

## Method 1: Using GitHub Web Interface (Easiest)

### Step 1: Download Project Files
1. Download all files from this conversation
2. Extract to a folder named `lab-dashboard`

### Step 2: Create Repository on GitHub
1. Go to https://github.com/new
2. Repository name: `lab-dashboard`
3. Description: `Grafana dashboard for visualizing lab projects, tasks, and team utilization`
4. Choose: Public or Private
5. **Do NOT initialize** with README, .gitignore, or license (we have these)
6. Click "Create repository"

### Step 3: Upload Files
1. On the new repository page, click "uploading an existing file"
2. Drag all project files and folders
3. Commit message: "Initial commit - Lab dashboard setup"
4. Click "Commit changes"

## Method 2: Using Git Command Line (Recommended)

### Step 1: Download and Organize Files
```bash
# Create project directory
mkdir lab-dashboard
cd lab-dashboard

# Copy all downloaded files here maintaining directory structure
# Structure should look like:
# lab-dashboard/
# ├── README.md
# ├── docker-compose.yml
# ├── init-db.sql
# ├── .gitignore
# ├── LICENSE
# ├── docs/
# │   ├── CUSTOMIZATION.md
# │   └── TROUBLESHOOTING.md
# └── grafana/
#     ├── provisioning/
#     │   ├── datasources/
#     │   │   └── datasource.yml
#     │   └── dashboards/
#     │       └── dashboard.yml
#     └── dashboards/
#         └── lab-overview.json
```

### Step 2: Initialize Git Repository
```bash
# Navigate to project directory
cd lab-dashboard

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit - Lab dashboard with Grafana and PostgreSQL"
```

### Step 3: Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `lab-dashboard`
3. Description: `Grafana dashboard for visualizing lab projects, tasks, and team utilization`
4. Choose visibility (Public/Private)
5. **Do NOT initialize** with README
6. Click "Create repository"

### Step 4: Push to GitHub
```bash
# Add GitHub remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/lab-dashboard.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Method 3: Using GitHub CLI (For Advanced Users)

```bash
# Install GitHub CLI if needed (https://cli.github.com/)

# Navigate to project directory
cd lab-dashboard

# Initialize and create repo in one command
gh repo create lab-dashboard --public --source=. --remote=origin --push

# Or for private repo
gh repo create lab-dashboard --private --source=. --remote=origin --push
```

## Post-Upload Setup

### Add Repository Topics
1. Go to your repository page
2. Click the gear icon next to "About"
3. Add topics: `grafana`, `dashboard`, `docker`, `postgresql`, `monitoring`, `visualization`
4. Save changes

### Add Repository Description
In the same "About" section, add:
```
🔬 Real-time Grafana dashboard for visualizing lab projects, personnel utilization, and task management. Docker-based setup with PostgreSQL backend.
```

### Enable GitHub Pages (Optional)
If you want to host documentation:
1. Settings → Pages
2. Source: Deploy from branch
3. Branch: main, folder: /docs
4. Save

### Add Screenshots
Create a `screenshots` folder and add dashboard images:
```bash
mkdir screenshots
# Add your dashboard screenshots here
git add screenshots/
git commit -m "Add dashboard screenshots"
git push
```

Update README.md to include:
```markdown
## Screenshots

![Main Dashboard](screenshots/main-dashboard.png)
![Project Overview](screenshots/project-overview.png)
```

## Keeping Repository Updated

### Making Changes Locally
```bash
# Make your changes to files

# Check what changed
git status

# Add changes
git add .

# Commit with message
git commit -m "Updated dashboard configuration"

# Push to GitHub
git push
```

### Syncing with GitHub
```bash
# Get latest from GitHub
git pull

# Or if you have conflicts
git fetch
git merge origin/main
```

## Repository Best Practices

### 1. Use Branches for Development
```bash
# Create new branch for features
git checkout -b feature/new-panel

# Make changes and commit
git add .
git commit -m "Add new personnel panel"

# Push branch to GitHub
git push -u origin feature/new-panel

# Create Pull Request on GitHub, then merge
```

### 2. Tag Releases
```bash
# Create version tag
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0

# Create GitHub release
gh release create v1.0.0 --title "v1.0.0 - Initial Release" --notes "First stable release"
```

### 3. Use .gitignore Properly
Already included, but verify it contains:
```
.env
*.log
.DS_Store
grafana-data/
postgres-data/
```

### 4. Protect Sensitive Data
Never commit:
- Passwords (use environment variables)
- API keys
- Personal data
- Backup files

Use `.env` file:
```bash
# Create .env (already in .gitignore)
GRAFANA_ADMIN_PASSWORD=your_password
POSTGRES_PASSWORD=your_db_password

# Update docker-compose.yml to use
environment:
  - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}
```

## Collaboration Setup

### Add Collaborators
1. Repository Settings → Collaborators
2. Add team members
3. Set permissions (Read, Write, Admin)

### Setup Branch Protection
1. Settings → Branches → Add rule
2. Branch name pattern: `main`
3. Enable:
   - Require pull request reviews
   - Require status checks to pass
   - Include administrators

### Enable Discussions
1. Settings → Features → Discussions
2. Enable discussions
3. Create categories: Q&A, Ideas, Show and Tell

## Useful GitHub Features

### README Badges
Add to top of README.md:
```markdown
![Docker](https://img.shields.io/badge/docker-compose-blue)
![Grafana](https://img.shields.io/badge/grafana-latest-orange)
![License](https://img.shields.io/github/license/YOUR_USERNAME/lab-dashboard)
![Stars](https://img.shields.io/github/stars/YOUR_USERNAME/lab-dashboard)
```

### Issue Templates
Create `.github/ISSUE_TEMPLATE/bug_report.md`:
```markdown
---
name: Bug Report
about: Report a problem
---

**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior.

**Expected behavior**
What you expected to happen.

**Environment:**
- OS: [e.g. Ubuntu 22.04]
- Docker version:
- Browser:
```

### Automated Actions
Create `.github/workflows/docker-test.yml`:
```yaml
name: Docker Build Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Test docker-compose
        run: docker-compose config
```

## Sharing Your Repository

### Generate Clone URL
Share this with others:
```
https://github.com/YOUR_USERNAME/lab-dashboard.git
```

### Create Quick Start Guide
Add to README:
```markdown
## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/lab-dashboard.git
cd lab-dashboard
docker-compose up -d
```

Access dashboard at http://localhost:3000
```

### Social Preview
1. Settings → Social Preview
2. Upload an image (1280x640px)
3. This appears when shared on social media

## Troubleshooting Git Issues

### Large files error
```bash
# If files are too large
git lfs install
git lfs track "*.sql"
git add .gitattributes
```

### Undo last commit
```bash
# Keep changes
git reset --soft HEAD~1

# Discard changes
git reset --hard HEAD~1
```

### Remove committed sensitive data
```bash
# Install BFG Repo Cleaner
# Then:
bfg --delete-files secrets.txt
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push --force
```

## Next Steps

After successful upload:

1. ✅ Verify all files are visible on GitHub
2. ✅ Test cloning the repository
3. ✅ Update repository description and topics
4. ✅ Add any screenshots or documentation
5. ✅ Share with your team
6. ✅ Set up branch protection if needed
7. ✅ Create first release tag (v1.0.0)

## Support

For Git/GitHub help:
- [GitHub Docs](https://docs.github.com/)
- [Git Handbook](https://guides.github.com/introduction/git-handbook/)
- [GitHub Skills](https://skills.github.com/)
