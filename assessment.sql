-- DASS-21 Assessment Tables
CREATE TABLE IF NOT EXISTS dass_assessments (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    assessment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    depression_score INT NOT NULL,
    anxiety_score INT NOT NULL,
    stress_score INT NOT NULL,
    depression_severity VARCHAR(50),
    anxiety_severity VARCHAR(50),
    stress_severity VARCHAR(50),
    overall_severity VARCHAR(50),
    is_completed BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_assessment_date (assessment_date)
);

CREATE TABLE IF NOT EXISTS dass_answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    assessment_id INT NOT NULL,
    question_number INT NOT NULL,
    answer_value INT NOT NULL CHECK (answer_value BETWEEN 0 AND 3),
    question_type ENUM('depression', 'anxiety', 'stress') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assessment_id) REFERENCES dass_assessments(assessment_id) ON DELETE CASCADE,
    UNIQUE KEY unique_assessment_question (assessment_id, question_number),
    INDEX idx_assessment_id (assessment_id),
    INDEX idx_question_type (question_type)
);

CREATE TABLE IF NOT EXISTS assessment_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    assessment_id INT,
    user_id INT,
    action_type VARCHAR(50) NOT NULL,
    action_details TEXT,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assessment_id) REFERENCES dass_assessments(assessment_id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_assessment_id (assessment_id),
    INDEX idx_user_id (user_id)
);

-- sample
-- Insert sample DASS-21 assessments for all users
INSERT INTO dass_assessments (user_id, depression_score, anxiety_score, stress_score, 
                              depression_severity, anxiety_severity, stress_severity, overall_severity, 
                              assessment_date) 
VALUES 
-- User 1 (Ali bin Ahmad) - Multiple assessments
(1, 12, 14, 16, 'Mild', 'Mild', 'Mild', 'Mild', '2024-12-01 10:30:00'),
(1, 8, 10, 12, 'Normal', 'Mild', 'Normal', 'Normal', '2024-11-15 14:20:00'),
(1, 16, 18, 20, 'Moderate', 'Moderate', 'Mild', 'Moderate', '2024-12-05 09:15:00'),

-- User 2 (Siti binti Mohd)
(2, 14, 12, 18, 'Mild', 'Mild', 'Mild', 'Mild', '2024-12-02 11:45:00'),
(2, 6, 8, 10, 'Normal', 'Normal', 'Normal', 'Normal', '2024-11-20 16:30:00'),

-- User 3 (Ahmad bin Ismail)
(3, 20, 16, 22, 'Moderate', 'Moderate', 'Moderate', 'Moderate', '2024-12-03 13:20:00'),
(3, 25, 20, 30, 'Severe', 'Severe', 'Severe', 'Severe', '2024-11-25 10:00:00'),

-- User 1 again (latest)
(1, 10, 12, 14, 'Normal', 'Mild', 'Normal', 'Normal', '2024-12-10 08:45:00'),

-- User 2 again
(2, 18, 14, 20, 'Mild', 'Mild', 'Mild', 'Mild', '2024-12-08 15:30:00'),

-- Additional sample assessments
(3, 30, 25, 35, 'Extremely Severe', 'Extremely Severe', 'Extremely Severe', 'Extremely Severe', '2024-12-07 11:10:00'),
(1, 4, 6, 8, 'Normal', 'Normal', 'Normal', 'Normal', '2024-11-30 17:45:00'),
(2, 22, 18, 24, 'Severe', 'Moderate', 'Moderate', 'Moderate', '2024-12-04 09:30:00');

-- Insert sample answers for assessment ID 1 (21 questions)
INSERT INTO dass_answers (assessment_id, question_number, answer_value, question_type) VALUES
(1, 1, 1, 'stress'),
(1, 2, 0, 'anxiety'),
(1, 3, 2, 'depression'),
(1, 4, 1, 'anxiety'),
(1, 5, 1, 'depression'),
(1, 6, 2, 'stress'),
(1, 7, 0, 'anxiety'),
(1, 8, 1, 'stress'),
(1, 9, 2, 'anxiety'),
(1, 10, 1, 'depression'),
(1, 11, 2, 'stress'),
(1, 12, 1, 'stress'),
(1, 13, 2, 'depression'),
(1, 14, 0, 'stress'),
(1, 15, 1, 'anxiety'),
(1, 16, 2, 'depression'),
(1, 17, 1, 'depression'),
(1, 18, 1, 'stress'),
(1, 19, 0, 'anxiety'),
(1, 20, 1, 'anxiety'),
(1, 21, 2, 'depression');

-- Insert answers for assessment ID 2
INSERT INTO dass_answers (assessment_id, question_number, answer_value, question_type) VALUES
(2, 1, 0, 'stress'),
(2, 2, 1, 'anxiety'),
(2, 3, 1, 'depression'),
(2, 4, 0, 'anxiety'),
(2, 5, 0, 'depression'),
(2, 6, 1, 'stress'),
(2, 7, 1, 'anxiety'),
(2, 8, 0, 'stress'),
(2, 9, 1, 'anxiety'),
(2, 10, 0, 'depression'),
(2, 11, 1, 'stress'),
(2, 12, 0, 'stress'),
(2, 13, 1, 'depression'),
(2, 14, 1, 'stress'),
(2, 15, 0, 'anxiety'),
(2, 16, 1, 'depression'),
(2, 17, 0, 'depression'),
(2, 18, 1, 'stress'),
(2, 19, 1, 'anxiety'),
(2, 20, 0, 'anxiety'),
(2, 21, 1, 'depression');

-- Insert answers for assessment ID 3
INSERT INTO dass_answers (assessment_id, question_number, answer_value, question_type) VALUES
(3, 1, 2, 'stress'),
(3, 2, 1, 'anxiety'),
(3, 3, 2, 'depression'),
(3, 4, 2, 'anxiety'),
(3, 5, 2, 'depression'),
(3, 6, 2, 'stress'),
(3, 7, 1, 'anxiety'),
(3, 8, 2, 'stress'),
(3, 9, 2, 'anxiety'),
(3, 10, 2, 'depression'),
(3, 11, 2, 'stress'),
(3, 12, 2, 'stress'),
(3, 13, 2, 'depression'),
(3, 14, 1, 'stress'),
(3, 15, 2, 'anxiety'),
(3, 16, 2, 'depression'),
(3, 17, 1, 'depression'),
(3, 18, 2, 'stress'),
(3, 19, 1, 'anxiety'),
(3, 20, 2, 'anxiety'),
(3, 21, 2, 'depression');

-- Insert assessment history records
INSERT INTO assessment_history (assessment_id, user_id, action_type, action_details) VALUES
(1, 1, 'CREATE', 'Assessment submitted by user'),
(2, 1, 'CREATE', 'Assessment submitted by user'),
(3, 1, 'CREATE', 'Assessment submitted by user'),
(4, 2, 'CREATE', 'Assessment submitted by user'),
(5, 2, 'CREATE', 'Assessment submitted by user'),
(6, 3, 'CREATE', 'Assessment submitted by user'),
(7, 3, 'CREATE', 'Assessment submitted by user'),
(8, 1, 'CREATE', 'Assessment submitted by user'),
(9, 2, 'CREATE', 'Assessment submitted by user'),
(10, 3, 'CREATE', 'Assessment submitted by user'),
(11, 1, 'CREATE', 'Assessment submitted by user'),
(12, 2, 'CREATE', 'Assessment submitted by user');

-- Add sample deletion history (for professional actions)
INSERT INTO assessment_history (assessment_id, user_id, action_type, action_details) VALUES
(5, 4, 'DELETE', 'Assessment deleted by admin - Duplicate entry');

-- View to get assessment statistics
CREATE VIEW assessment_statistics AS
SELECT 
    COUNT(*) as total_assessments,
    AVG(depression_score) as avg_depression,
    AVG(anxiety_score) as avg_anxiety,
    AVG(stress_score) as avg_stress,
    SUM(CASE WHEN overall_severity = 'Normal' THEN 1 ELSE 0 END) as normal_count,
    SUM(CASE WHEN overall_severity = 'Mild' THEN 1 ELSE 0 END) as mild_count,
    SUM(CASE WHEN overall_severity = 'Moderate' THEN 1 ELSE 0 END) as moderate_count,
    SUM(CASE WHEN overall_severity = 'Severe' THEN 1 ELSE 0 END) as severe_count,
    SUM(CASE WHEN overall_severity = 'Extremely Severe' THEN 1 ELSE 0 END) as extremely_severe_count
FROM dass_assessments;

-- View to get user assessment history
CREATE VIEW user_assessment_history AS
SELECT 
    u.user_id,
    u.full_name,
    u.username,
    COUNT(da.assessment_id) as assessment_count,
    MAX(da.assessment_date) as last_assessment,
    AVG(da.depression_score) as avg_depression,
    AVG(da.anxiety_score) as avg_anxiety,
    AVG(da.stress_score) as avg_stress
FROM users u
LEFT JOIN dass_assessments da ON u.user_id = da.user_id
GROUP BY u.user_id, u.full_name, u.username;

-- Create a stored procedure for monthly statistics
DELIMITER //
CREATE PROCEDURE GetMonthlyAssessmentStats(IN year INT)
BEGIN
    SELECT 
        MONTH(assessment_date) as month,
        COUNT(*) as assessment_count,
        AVG(depression_score) as avg_depression,
        AVG(anxiety_score) as avg_anxiety,
        AVG(stress_score) as avg_stress
    FROM dass_assessments
    WHERE YEAR(assessment_date) = year
    GROUP BY MONTH(assessment_date)
    ORDER BY month;
END //
DELIMITER ;

-- Create trigger to automatically log assessment creation
DELIMITER //
CREATE TRIGGER after_assessment_insert
AFTER INSERT ON dass_assessments
FOR EACH ROW
BEGIN
    INSERT INTO assessment_history (assessment_id, user_id, action_type, action_details)
    VALUES (NEW.assessment_id, NEW.user_id, 'CREATE', 'Assessment created via form submission');
END //
DELIMITER ;

-- Create trigger for assessment deletion
DELIMITER //
CREATE TRIGGER before_assessment_delete
BEFORE DELETE ON dass_assessments
FOR EACH ROW
BEGIN
    -- Archive answers before deletion
    INSERT INTO archived_dass_answers 
    SELECT * FROM dass_answers WHERE assessment_id = OLD.assessment_id;
    
    -- Delete answers
    DELETE FROM dass_answers WHERE assessment_id = OLD.assessment_id;
END //
DELIMITER ;

-- Create archived answers table (if needed for compliance)
CREATE TABLE IF NOT EXISTS archived_dass_answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    assessment_id INT NOT NULL,
    question_number INT NOT NULL,
    answer_value INT NOT NULL,
    question_type VARCHAR(50) NOT NULL,
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enhanced Database Schema for Self-Assessment Module

-- 1. Add indexes for better performance
CREATE INDEX idx_dass_user_date ON dass_assessments(user_id, assessment_date DESC);
CREATE INDEX idx_dass_overall_severity ON dass_assessments(overall_severity);
CREATE INDEX idx_dass_completed ON dass_assessments(is_completed);
CREATE INDEX idx_answers_assessment ON dass_answers(assessment_id);
CREATE INDEX idx_answers_question ON dass_answers(question_number);
CREATE INDEX idx_history_assessment ON assessment_history(assessment_id);
CREATE INDEX idx_history_user ON assessment_history(user_id);

-- 2. Add columns for better tracking
ALTER TABLE dass_assessments 
ADD COLUMN time_taken_minutes INT DEFAULT NULL,
ADD COLUMN device_type VARCHAR(50) DEFAULT 'web',
ADD COLUMN browser_info VARCHAR(255) DEFAULT NULL,
ADD COLUMN ip_address VARCHAR(45) DEFAULT NULL,
ADD COLUMN completion_status ENUM('completed', 'in_progress', 'abandoned') DEFAULT 'completed',
ADD INDEX idx_completion_status (completion_status);

-- 3. Create view for dashboard statistics
CREATE VIEW dass_dashboard_stats AS
SELECT 
    DATE(assessment_date) as assessment_date,
    COUNT(*) as daily_count,
    AVG(depression_score) as avg_depression,
    AVG(anxiety_score) as avg_anxiety,
    AVG(stress_score) as avg_stress,
    SUM(CASE WHEN overall_severity = 'Normal' THEN 1 ELSE 0 END) as normal_count,
    SUM(CASE WHEN overall_severity = 'Mild' THEN 1 ELSE 0 END) as mild_count,
    SUM(CASE WHEN overall_severity = 'Moderate' THEN 1 ELSE 0 END) as moderate_count,
    SUM(CASE WHEN overall_severity = 'Severe' THEN 1 ELSE 0 END) as severe_count,
    SUM(CASE WHEN overall_severity = 'Extremely Severe' THEN 1 ELSE 0 END) as extremely_severe_count
FROM dass_assessments 
WHERE is_completed = TRUE
GROUP BY DATE(assessment_date)
ORDER BY assessment_date DESC;

-- 4. Create view for user progress tracking
CREATE VIEW user_assessment_progress AS
SELECT 
    u.user_id,
    u.full_name,
    u.username,
    u.email,
    COUNT(da.assessment_id) as total_assessments,
    MAX(da.assessment_date) as last_assessment_date,
    MIN(da.assessment_date) as first_assessment_date,
    AVG(da.depression_score) as avg_depression_score,
    AVG(da.anxiety_score) as avg_anxiety_score,
    AVG(da.stress_score) as avg_stress_score,
    CASE 
        WHEN COUNT(da.assessment_id) = 0 THEN 'Never assessed'
        WHEN DATEDIFF(CURDATE(), MAX(da.assessment_date)) <= 7 THEN 'Recently assessed'
        WHEN DATEDIFF(CURDATE(), MAX(da.assessment_date)) <= 30 THEN 'Assessed this month'
        ELSE 'Needs follow-up'
    END as assessment_status
FROM users u
LEFT JOIN dass_assessments da ON u.user_id = da.user_id AND da.is_completed = TRUE
GROUP BY u.user_id, u.full_name, u.username, u.email;

-- 5. Create trigger to update assessment history
DELIMITER //
CREATE TRIGGER after_dass_assessment_insert
AFTER INSERT ON dass_assessments
FOR EACH ROW
BEGIN
    INSERT INTO assessment_history (assessment_id, user_id, action_type, action_details)
    VALUES (NEW.assessment_id, NEW.user_id, 'CREATE', 
            CONCAT('Assessment created with scores - D:', NEW.depression_score, 
                   ' A:', NEW.anxiety_score, ' S:', NEW.stress_score));
END //
DELIMITER ;

-- 6. Create stored procedure for monthly report
DELIMITER //
CREATE PROCEDURE GetMonthlyAssessmentReport(IN year INT, IN month INT)
BEGIN
    SELECT 
        u.full_name,
        u.username,
        da.assessment_date,
        da.depression_score,
        da.depression_severity,
        da.anxiety_score,
        da.anxiety_severity,
        da.stress_score,
        da.stress_severity,
        da.overall_severity
    FROM dass_assessments da
    JOIN users u ON da.user_id = u.user_id
    WHERE YEAR(da.assessment_date) = year 
      AND MONTH(da.assessment_date) = month
      AND da.is_completed = TRUE
    ORDER BY da.assessment_date DESC;
END //
DELIMITER ;

-- 7. Create function to calculate assessment trend
DELIMITER //
CREATE FUNCTION GetAssessmentTrend(user_id_param INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE last_depression INT;
    DECLARE prev_depression INT;
    DECLARE trend VARCHAR(20);
    
    -- Get last two depression scores
    SELECT depression_score INTO last_depression
    FROM dass_assessments 
    WHERE user_id = user_id_param 
    AND is_completed = TRUE
    ORDER BY assessment_date DESC 
    LIMIT 1;
    
    SELECT depression_score INTO prev_depression
    FROM dass_assessments 
    WHERE user_id = user_id_param 
    AND is_completed = TRUE
    ORDER BY assessment_date DESC 
    LIMIT 1, 1;
    
    IF last_depression IS NULL THEN
        SET trend = 'No assessment';
    ELSEIF prev_depression IS NULL THEN
        SET trend = 'First assessment';
    ELSEIF last_depression > prev_depression THEN
        SET trend = 'Increasing';
    ELSEIF last_depression < prev_depression THEN
        SET trend = 'Decreasing';
    ELSE
        SET trend = 'Stable';
    END IF;
    
    RETURN trend;
END //
DELIMITER ;