package smilespace.dao;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import smilespace.model.DassAnswer;
import smilespace.model.DassAssessment;

@Repository
@Transactional
public class DassAssessmentDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private final RowMapper<DassAssessment> assessmentRowMapper = (rs, rowNum) -> {
        DassAssessment assessment = new DassAssessment();
        assessment.setAssessmentId(rs.getInt("assessment_id"));
        assessment.setUserId(rs.getInt("user_id"));
        
        Timestamp assessmentTimestamp = rs.getTimestamp("assessment_date");
        if (assessmentTimestamp != null) {
            assessment.setAssessmentDate(new Date(assessmentTimestamp.getTime()));
        }
        
        assessment.setDepressionScore(rs.getInt("depression_score"));
        assessment.setAnxietyScore(rs.getInt("anxiety_score"));
        assessment.setStressScore(rs.getInt("stress_score"));
        assessment.setDepressionSeverity(rs.getString("depression_severity"));
        assessment.setAnxietySeverity(rs.getString("anxiety_severity"));
        assessment.setStressSeverity(rs.getString("stress_severity"));
        assessment.setOverallSeverity(rs.getString("overall_severity"));
        assessment.setCompleted(rs.getBoolean("is_completed"));
        
        // User info if joined
        try {
            assessment.setUserFullName(rs.getString("full_name"));
            assessment.setUserName(rs.getString("username"));
        } catch (Exception e) {
            // Ignore if columns don't exist
        }
        
        return assessment;
    };
    
    private final RowMapper<DassAnswer> answerRowMapper = (rs, rowNum) -> {
        DassAnswer answer = new DassAnswer();
        answer.setAnswerId(rs.getInt("answer_id"));
        answer.setAssessmentId(rs.getInt("assessment_id"));
        answer.setQuestionNumber(rs.getInt("question_number"));
        answer.setAnswerValue(rs.getInt("answer_value"));
        answer.setQuestionType(rs.getString("question_type"));
        return answer;
    };
    
    public Integer createAssessment(DassAssessment assessment) {
        System.out.println("DEBUG [DassAssessmentDAO.createAssessment]: Starting...");
        System.out.println("DEBUG: User ID: " + assessment.getUserId());
        System.out.println("DEBUG: Depression Score: " + assessment.getDepressionScore());
        System.out.println("DEBUG: Anxiety Score: " + assessment.getAnxietyScore());
        System.out.println("DEBUG: Stress Score: " + assessment.getStressScore());
        
        String sql = "INSERT INTO dass_assessments " +
                    "(user_id, depression_score, anxiety_score, stress_score, " +
                    "depression_severity, anxiety_severity, stress_severity, overall_severity, is_completed, assessment_date) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        
        try {
            System.out.println("DEBUG: Executing SQL: " + sql);
            
            int affectedRows = jdbcTemplate.update(sql,
                assessment.getUserId(),
                assessment.getDepressionScore(),
                assessment.getAnxietyScore(),
                assessment.getStressScore(),
                assessment.getDepressionSeverity(),
                assessment.getAnxietySeverity(),
                assessment.getStressSeverity(),
                assessment.getOverallSeverity(),
                assessment.isCompleted()
            );
            
            System.out.println("DEBUG: Insert affected rows: " + affectedRows);
            
            if (affectedRows > 0) {
                Integer assessmentId = jdbcTemplate.queryForObject(
                    "SELECT LAST_INSERT_ID()", Integer.class);
                System.out.println("DEBUG: Created assessment ID: " + assessmentId);
                return assessmentId;
            } else {
                System.err.println("ERROR: No rows affected in assessment insert");
                return null;
            }
        } catch (Exception e) {
            System.err.println("ERROR creating assessment: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    public boolean saveAnswers(int assessmentId, List<DassAnswer> answers) {
    System.out.println("DEBUG [DassAssessmentDAO.saveAnswers]: Starting...");
    System.out.println("DEBUG: Assessment ID: " + assessmentId);
    System.out.println("DEBUG: Number of answers to save: " + answers.size());
    
    if (answers == null || answers.isEmpty()) {
        System.err.println("ERROR: No answers to save");
        return false;
    }
    
    // First, delete any existing answers for this assessment
    String deleteSql = "DELETE FROM dass_answers WHERE assessment_id = ?";
    
    try {
        int deleted = jdbcTemplate.update(deleteSql, assessmentId);
        System.out.println("DEBUG: Deleted " + deleted + " existing answers");
    } catch (Exception e) {
        System.err.println("WARNING: Could not clear existing answers: " + e.getMessage());
    }
    
    // Insert new answers
    String insertSql = "INSERT INTO dass_answers (assessment_id, question_number, answer_value, question_type) " +
                      "VALUES (?, ?, ?, ?)";
    
    try {
        int successCount = 0;
        List<Object[]> batchArgs = new ArrayList<>();
        
        for (DassAnswer answer : answers) {
            System.out.println("DEBUG: Preparing answer - Q" + answer.getQuestionNumber() + 
                             ": value=" + answer.getAnswerValue() + 
                             ", type=" + answer.getQuestionType());
            
            batchArgs.add(new Object[]{
                assessmentId,
                answer.getQuestionNumber(),
                answer.getAnswerValue(),
                answer.getQuestionType()
            });
        }
        
        // Batch insert for better performance
        int[] batchResults = jdbcTemplate.batchUpdate(insertSql, batchArgs);
        successCount = batchResults.length;
        
        System.out.println("DEBUG: Successfully saved " + successCount + " answers");
        return successCount == answers.size();
        
    } catch (Exception e) {
        System.err.println("ERROR saving answers: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
    
    public DassAssessment getAssessmentById(int assessmentId) {
        String sql = "SELECT da.*, u.full_name, u.username " +
                    "FROM dass_assessments da " +
                    "JOIN users u ON da.user_id = u.user_id " +
                    "WHERE da.assessment_id = ?";
        
        try {
            DassAssessment assessment = jdbcTemplate.queryForObject(sql, assessmentRowMapper, assessmentId);
            if (assessment != null) {
                assessment.setAnswers(getAnswersByAssessmentId(assessmentId));
            }
            return assessment;
        } catch (Exception e) {
            System.err.println("Error getting assessment by ID: " + e.getMessage());
            return null;
        }
    }
    
    public List<DassAssessment> getAssessmentsByUserId(int userId) {
        String sql = "SELECT * FROM dass_assessments WHERE user_id = ? ORDER BY assessment_date DESC";
        
        try {
            return jdbcTemplate.query(sql, assessmentRowMapper, userId);
        } catch (Exception e) {
            System.err.println("Error getting assessments by user ID: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public List<DassAssessment> getAllAssessments() {
        String sql = "SELECT da.*, u.full_name, u.username " +
                    "FROM dass_assessments da " +
                    "JOIN users u ON da.user_id = u.user_id " +
                    "ORDER BY da.assessment_date DESC";
        
        try {
            return jdbcTemplate.query(sql, assessmentRowMapper);
        } catch (Exception e) {
            System.err.println("Error getting all assessments: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public List<DassAnswer> getAnswersByAssessmentId(int assessmentId) {
        String sql = "SELECT * FROM dass_answers WHERE assessment_id = ? ORDER BY question_number";
        
        try {
            return jdbcTemplate.query(sql, answerRowMapper, assessmentId);
        } catch (Exception e) {
            System.err.println("Error getting answers by assessment ID: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public boolean deleteAssessment(int assessmentId, Integer userId) {
        String sql = "DELETE FROM dass_assessments WHERE assessment_id = ?";
        
        try {
            // First delete answers (cascade should handle this, but we do it explicitly)
            String deleteAnswersSql = "DELETE FROM dass_answers WHERE assessment_id = ?";
            jdbcTemplate.update(deleteAnswersSql, assessmentId);
            
            // Log history before deletion
            logHistory(assessmentId, userId, "DELETE", "Assessment deleted");
            
            // Delete assessment
            int affectedRows = jdbcTemplate.update(sql, assessmentId);
            return affectedRows > 0;
        } catch (Exception e) {
            System.err.println("Error deleting assessment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public List<DassAssessment> searchAssessments(String searchTerm, String severity) {
        StringBuilder sql = new StringBuilder(
            "SELECT da.*, u.full_name, u.username " +
            "FROM dass_assessments da " +
            "JOIN users u ON da.user_id = u.user_id " +
            "WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR u.username LIKE ?)");
            String searchParam = "%" + searchTerm + "%";
            params.add(searchParam);
            params.add(searchParam);
        }
        
        if (severity != null && !"All Severities".equals(severity) && !severity.isEmpty()) {
            sql.append(" AND da.overall_severity = ?");
            params.add(severity);
        }
        
        sql.append(" ORDER BY da.assessment_date DESC");
        
        try {
            return jdbcTemplate.query(sql.toString(), assessmentRowMapper, params.toArray());
        } catch (Exception e) {
            System.err.println("Error searching assessments: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public Map<String, Double> getAverageScores() {
        Map<String, Double> averages = new HashMap<>();
        String sql = "SELECT " +
                    "AVG(depression_score) as avg_depression, " +
                    "AVG(anxiety_score) as avg_anxiety, " +
                    "AVG(stress_score) as avg_stress " +
                    "FROM dass_assessments WHERE is_completed = TRUE";
        
        try {
            Map<String, Object> result = jdbcTemplate.queryForMap(sql);
            Object depAvg = result.get("avg_depression");
            Object anxAvg = result.get("avg_anxiety");
            Object strAvg = result.get("avg_stress");
            
            averages.put("depression", depAvg != null ? ((Number) depAvg).doubleValue() : 0.0);
            averages.put("anxiety", anxAvg != null ? ((Number) anxAvg).doubleValue() : 0.0);
            averages.put("stress", strAvg != null ? ((Number) strAvg).doubleValue() : 0.0);
        } catch (Exception e) {
            System.err.println("Error getting average scores: " + e.getMessage());
            e.printStackTrace();
            averages.put("depression", 0.0);
            averages.put("anxiety", 0.0);
            averages.put("stress", 0.0);
        }
        
        return averages;
    }
    
    public Map<String, Integer> getSeverityDistribution() {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT overall_severity, COUNT(*) as count " +
                    "FROM dass_assessments " +
                    "WHERE is_completed = TRUE " +
                    "GROUP BY overall_severity";
        
        try {
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);
            for (Map<String, Object> row : results) {
                String severity = (String) row.get("overall_severity");
                Integer count = ((Number) row.get("count")).intValue();
                distribution.put(severity, count);
            }
            
            // Ensure all severity levels are in the map
            String[] severities = {"Normal", "Mild", "Moderate", "Severe", "Extremely Severe"};
            for (String severity : severities) {
                distribution.putIfAbsent(severity, 0);
            }
            
        } catch (Exception e) {
            System.err.println("Error getting severity distribution: " + e.getMessage());
            e.printStackTrace();
        }
        
        return distribution;
    }
    
    private void logHistory(Integer assessmentId, Integer userId, String actionType, String details) {
        String sql = "INSERT INTO assessment_history (assessment_id, user_id, action_type, action_details) " +
                    "VALUES (?, ?, ?, ?)";
        
        try {
            jdbcTemplate.update(sql, assessmentId, userId, actionType, details);
        } catch (Exception e) {
            System.err.println("Error logging assessment history: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public List<Map<String, Object>> getAssessmentHistory(int assessmentId) {
        String sql = "SELECT ah.*, u.full_name as performed_by " +
                    "FROM assessment_history ah " +
                    "LEFT JOIN users u ON ah.user_id = u.user_id " +
                    "WHERE ah.assessment_id = ? " +
                    "ORDER BY ah.performed_at DESC";
        
        try {
            return jdbcTemplate.queryForList(sql, assessmentId);
        } catch (Exception e) {
            System.err.println("Error getting assessment history: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    // Get assessment statistics for dashboard
    public Map<String, Object> getAssessmentStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            // Total assessments
            String totalSql = "SELECT COUNT(*) as total FROM dass_assessments WHERE is_completed = TRUE";
            Integer total = jdbcTemplate.queryForObject(totalSql, Integer.class);
            stats.put("totalAssessments", total != null ? total : 0);
            
            // Today's assessments
            String todaySql = "SELECT COUNT(*) as today FROM dass_assessments " +
                             "WHERE DATE(assessment_date) = CURDATE() AND is_completed = TRUE";
            Integer today = jdbcTemplate.queryForObject(todaySql, Integer.class);
            stats.put("todayAssessments", today != null ? today : 0);
            
            // This week's assessments
            String weekSql = "SELECT COUNT(*) as week FROM dass_assessments " +
                            "WHERE YEARWEEK(assessment_date) = YEARWEEK(CURDATE()) AND is_completed = TRUE";
            Integer week = jdbcTemplate.queryForObject(weekSql, Integer.class);
            stats.put("weekAssessments", week != null ? week : 0);
            
            // Most common severity
            String commonSeveritySql = "SELECT overall_severity, COUNT(*) as count " +
                                      "FROM dass_assessments " +
                                      "WHERE is_completed = TRUE " +
                                      "GROUP BY overall_severity " +
                                      "ORDER BY count DESC " +
                                      "LIMIT 1";
            try {
                Map<String, Object> commonSeverity = jdbcTemplate.queryForMap(commonSeveritySql);
                stats.put("mostCommonSeverity", commonSeverity.get("overall_severity"));
                stats.put("mostCommonSeverityCount", commonSeverity.get("count"));
            } catch (Exception e) {
                stats.put("mostCommonSeverity", "No data");
                stats.put("mostCommonSeverityCount", 0);
            }
            
        } catch (Exception e) {
            System.err.println("Error getting assessment statistics: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
}