package smilespace.model;

public class DassAnswer {
    private int answerId;
    private int assessmentId;
    private int questionNumber;
    private int answerValue;
    private String questionType;
    
    // Getters and setters
    public int getAnswerId() { return answerId; }
    public void setAnswerId(int answerId) { this.answerId = answerId; }
    
    public int getAssessmentId() { return assessmentId; }
    public void setAssessmentId(int assessmentId) { this.assessmentId = assessmentId; }
    
    public int getQuestionNumber() { return questionNumber; }
    public void setQuestionNumber(int questionNumber) { this.questionNumber = questionNumber; }
    
    public int getAnswerValue() { return answerValue; }
    public void setAnswerValue(int answerValue) { this.answerValue = answerValue; }
    
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
}