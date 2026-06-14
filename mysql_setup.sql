CREATE DATABASE IF NOT EXISTS forgemind_db;
USE forgemind_db;

CREATE TABLE IF NOT EXISTS health_scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    production_score INT,
    energy_score INT,
    workforce_score INT,
    inventory_score INT
);

CREATE TABLE IF NOT EXISTS insights (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS copilot_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    query_text TEXT,
    response_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Demo Data
INSERT INTO health_scores (production_score, energy_score, workforce_score, inventory_score) 
VALUES (82, 75, 91, 88);

INSERT INTO insights (title, description, type) VALUES 
('Line A Performance Drop', 'Throughput is 15% below baseline. Maintenance Agent suggests inspecting Packaging Module servo motors.', 'warning'),
('Energy Anomaly Detected', 'Oven 3 on Line B failed to enter standby mode during shift change. Wasted: 450 kWh.', 'error'),
('Shift 1 Summary', '98% quality pass rate. Workforce efficiency at 92%. Great job team!', 'success');
