package smilespace.model;

import java.util.Date;
import java.util.List;

public class DassAssessment {
    private int assessmentId;
    private int userId;
    private Date assessmentDate;
    private int depressionScore;
    private int anxietyScore;
    private int stressScore;
    private String depressionSeverity;
    private String anxietySeverity;
    private String stressSeverity;
    private String overallSeverity;
    private boolean isCompleted;
    private String userName;
    private String userFullName;
    private List<DassAnswer> answers;
    
    // Getters and setters
    public int getAssessmentId() { return assessmentId; }
    public void setAssessmentId(int assessmentId) { this.assessmentId = assessmentId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public Date getAssessmentDate() { return assessmentDate; }
    public void setAssessmentDate(Date assessmentDate) { this.assessmentDate = assessmentDate; }
    
    public int getDepressionScore() { return depressionScore; }
    public void setDepressionScore(int depressionScore) { this.depressionScore = depressionScore; }
    
    public int getAnxietyScore() { return anxietyScore; }
    public void setAnxietyScore(int anxietyScore) { this.anxietyScore = anxietyScore; }
    
    public int getStressScore() { return stressScore; }
    public void setStressScore(int stressScore) { this.stressScore = stressScore; }
    
    public String getDepressionSeverity() { return depressionSeverity; }
    public void setDepressionSeverity(String depressionSeverity) { this.depressionSeverity = depressionSeverity; }
    
    public String getAnxietySeverity() { return anxietySeverity; }
    public void setAnxietySeverity(String anxietySeverity) { this.anxietySeverity = anxietySeverity; }
    
    public String getStressSeverity() { return stressSeverity; }
    public void setStressSeverity(String stressSeverity) { this.stressSeverity = stressSeverity; }
    
    public String getOverallSeverity() { return overallSeverity; }
    public void setOverallSeverity(String overallSeverity) { this.overallSeverity = overallSeverity; }
    
    public boolean isCompleted() { return isCompleted; }
    public void setCompleted(boolean completed) { isCompleted = completed; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }
    
    public List<DassAnswer> getAnswers() { return answers; }
    public void setAnswers(List<DassAnswer> answers) { this.answers = answers; }
}