-- Future Technologies Lab Database Schema
-- Initialize database with tables and sample data

-- Create tables for lab data management
CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    start_date DATE,
    end_date DATE,
    completion_percentage INTEGER DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS personnel (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL,
    utilization_percentage INTEGER DEFAULT 0,
    current_project_id INTEGER REFERENCES projects(id),
    email VARCHAR(255),
    skills TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    project_id INTEGER REFERENCES projects(id),
    assigned_to INTEGER REFERENCES personnel(id),
    status VARCHAR(50) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    due_date DATE,
    estimated_hours INTEGER,
    actual_hours INTEGER,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample projects
INSERT INTO projects (name, status, priority, start_date, end_date, completion_percentage, description) VALUES
('Quantum Computing Research', 'In Progress', 'High', '2026-01-01', '2026-06-30', 45, 'Developing quantum algorithms for cryptography applications'),
('AI Ethics Framework', 'In Progress', 'High', '2026-01-15', '2026-05-15', 60, 'Creating comprehensive ethical guidelines for AI development'),
('Neural Interface Prototype', 'Planning', 'Medium', '2026-02-01', '2026-08-31', 15, 'Brain-computer interface for assistive technology'),
('Sustainable Energy Systems', 'In Progress', 'High', '2025-12-01', '2026-04-30', 75, 'Next-generation solar panel efficiency improvements'),
('Augmented Reality Platform', 'On Hold', 'Low', '2026-01-20', '2026-07-20', 30, 'AR platform for remote collaboration'),
('Blockchain Security', 'In Progress', 'Medium', '2026-01-10', '2026-05-30', 50, 'Enhanced security protocols for distributed ledgers'),
('Robotics Automation', 'Planning', 'High', '2026-02-15', '2026-10-15', 10, 'Automated manufacturing systems with ML integration'),
('Climate Modeling AI', 'In Progress', 'High', '2025-11-01', '2026-06-30', 65, 'Machine learning models for climate prediction');

-- Insert sample personnel
INSERT INTO personnel (name, role, utilization_percentage, current_project_id, email, skills) VALUES
('Dr. Sarah Chen', 'Lead Researcher', 85, 1, 'sarah.chen@futuretech.lab', ARRAY['Quantum Physics', 'Algorithm Design', 'Python']),
('James Rodriguez', 'AI Specialist', 92, 2, 'james.rodriguez@futuretech.lab', ARRAY['Machine Learning', 'Ethics', 'TensorFlow']),
('Maya Patel', 'Hardware Engineer', 78, 3, 'maya.patel@futuretech.lab', ARRAY['Circuit Design', 'Embedded Systems', 'CAD']),
('Alex Thompson', 'Data Scientist', 88, 1, 'alex.thompson@futuretech.lab', ARRAY['Statistics', 'Data Analysis', 'R', 'Python']),
('Dr. Emily Wong', 'Ethics Lead', 70, 2, 'emily.wong@futuretech.lab', ARRAY['Philosophy', 'Policy', 'Research']),
('Marcus Johnson', 'Systems Engineer', 95, 4, 'marcus.johnson@futuretech.lab', ARRAY['Solar Technology', 'Electronics', 'Testing']),
('Zara Ali', 'UX Researcher', 45, 5, 'zara.ali@futuretech.lab', ARRAY['User Research', 'Design', 'Prototyping']),
('David Kim', 'Software Developer', 82, 4, 'david.kim@futuretech.lab', ARRAY['Full Stack', 'JavaScript', 'DevOps']),
('Rachel Foster', 'Blockchain Architect', 80, 6, 'rachel.foster@futuretech.lab', ARRAY['Cryptography', 'Distributed Systems', 'Solidity']),
('Chen Li', 'Robotics Engineer', 60, 7, 'chen.li@futuretech.lab', ARRAY['ROS', 'Computer Vision', 'C++']),
('Dr. Aisha Ibrahim', 'Climate Scientist', 90, 8, 'aisha.ibrahim@futuretech.lab', ARRAY['Climate Science', 'Modeling', 'Data Science']);

-- Insert sample tasks
INSERT INTO tasks (title, project_id, assigned_to, status, priority, due_date, estimated_hours, actual_hours, description) VALUES
('Qubit stability testing', 1, 1, 'In Progress', 'High', '2026-02-28', 120, 85, 'Test quantum bit coherence times under various conditions'),
('Algorithm optimization', 1, 4, 'In Progress', 'High', '2026-03-15', 80, 45, 'Optimize Shor algorithm implementation'),
('Ethics policy draft', 2, 5, 'Completed', 'High', '2026-02-01', 40, 42, 'Draft initial policy framework document'),
('Stakeholder interviews', 2, 2, 'In Progress', 'Medium', '2026-02-20', 60, 30, 'Conduct interviews with 20+ stakeholders'),
('Neural sensor design', 3, 3, 'Planning', 'Medium', '2026-03-01', 100, 10, 'Design EEG sensor array layout'),
('Energy efficiency analysis', 4, 6, 'In Progress', 'High', '2026-02-15', 70, 55, 'Analyze current panel efficiency metrics'),
('Solar panel integration', 4, 6, 'In Progress', 'High', '2026-03-01', 90, 40, 'Integrate new photovoltaic materials'),
('AR interface mockups', 5, 7, 'On Hold', 'Low', '2026-04-01', 50, 20, 'Create initial UI/UX mockups'),
('Smart contract audit', 6, 9, 'In Progress', 'High', '2026-02-25', 80, 60, 'Security audit of core contracts'),
('Consensus mechanism design', 6, 9, 'In Progress', 'Medium', '2026-03-10', 100, 45, 'Design improved consensus protocol'),
('Robot arm calibration', 7, 10, 'Planning', 'High', '2026-03-20', 60, 5, 'Calibrate 6-axis robotic arm'),
('ML model training', 8, 11, 'In Progress', 'High', '2026-02-28', 150, 120, 'Train climate prediction models on historical data'),
('Data validation', 8, 4, 'In Progress', 'Medium', '2026-02-18', 40, 35, 'Validate climate dataset integrity'),
('Literature review', 1, 1, 'Completed', 'Medium', '2026-01-15', 30, 28, 'Review recent quantum computing papers'),
('Prototype assembly', 3, 3, 'Not Started', 'Low', '2026-04-01', 80, 0, 'Assemble first neural interface prototype');

-- Create useful views for Grafana queries
CREATE OR REPLACE VIEW project_summary AS
SELECT 
    p.id,
    p.name,
    p.status,
    p.priority,
    p.completion_percentage,
    p.start_date,
    p.end_date,
    COUNT(DISTINCT t.id) as task_count,
    COUNT(DISTINCT t.assigned_to) as team_size,
    SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) as completed_tasks,
    SUM(t.actual_hours) as total_hours_spent
FROM projects p
LEFT JOIN tasks t ON p.id = t.project_id
GROUP BY p.id, p.name, p.status, p.priority, p.completion_percentage, p.start_date, p.end_date
ORDER BY p.priority, p.name;

CREATE OR REPLACE VIEW utilization_summary AS
SELECT 
    ROUND(AVG(utilization_percentage), 2) as avg_utilization,
    MAX(utilization_percentage) as max_utilization,
    MIN(utilization_percentage) as min_utilization,
    COUNT(*) as total_personnel,
    COUNT(CASE WHEN utilization_percentage > 80 THEN 1 END) as high_utilization_count,
    COUNT(CASE WHEN utilization_percentage < 60 THEN 1 END) as low_utilization_count
FROM personnel;

CREATE OR REPLACE VIEW task_status_summary AS
SELECT 
    status,
    COUNT(*) as count,
    SUM(estimated_hours) as estimated_hours,
    SUM(actual_hours) as actual_hours
FROM tasks
GROUP BY status
ORDER BY 
    CASE status 
        WHEN 'In Progress' THEN 1
        WHEN 'Not Started' THEN 2
        WHEN 'Planning' THEN 3
        WHEN 'On Hold' THEN 4
        WHEN 'Completed' THEN 5
    END;

CREATE OR REPLACE VIEW personnel_workload AS
SELECT 
    pe.id,
    pe.name,
    pe.role,
    pe.utilization_percentage,
    p.name as current_project,
    COUNT(t.id) as active_tasks,
    SUM(CASE WHEN t.status = 'In Progress' THEN 1 ELSE 0 END) as in_progress_tasks,
    SUM(t.estimated_hours - COALESCE(t.actual_hours, 0)) as remaining_hours
FROM personnel pe
LEFT JOIN projects p ON pe.current_project_id = p.id
LEFT JOIN tasks t ON pe.id = t.assigned_to AND t.status != 'Completed'
GROUP BY pe.id, pe.name, pe.role, pe.utilization_percentage, p.name
ORDER BY pe.utilization_percentage DESC;

-- Create indexes for better query performance
CREATE INDEX idx_tasks_project ON tasks(project_id);
CREATE INDEX idx_tasks_assigned ON tasks(assigned_to);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_personnel_project ON personnel(current_project_id);

-- Insert timestamp for tracking data freshness
CREATE TABLE IF NOT EXISTS metadata (
    key VARCHAR(255) PRIMARY KEY,
    value TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO metadata (key, value) VALUES 
('last_updated', CURRENT_TIMESTAMP::TEXT),
('version', '1.0'),
('environment', 'production');

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO labuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO labuser;
