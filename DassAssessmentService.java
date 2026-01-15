package smilespace.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import smilespace.dao.DassAssessmentDAO;
import smilespace.model.DassAnswer;
import smilespace.model.DassAssessment;

@Service
@Transactional
public class DassAssessmentService {
    
    @Autowired
    private DassAssessmentDAO dassAssessmentDAO;
    
    // DASS-21 questions mapping
    private static final String[] QUESTIONS = {
        "I found it hard to wind down",
        "I was aware of dryness of my mouth",
        "I couldn't seem to experience any positive feeling at all",
        "I experienced breathing difficulty",
        "I found it difficult to work up the initiative to do things",
        "I tended to over-react to situations",
        "I experienced trembling",
        "I felt that I was using a lot of nervous energy",
        "I was worried about situations in which I might panic and make a fool of myself",
        "I felt that I had nothing to look forward to",
        "I found myself getting agitated",
        "I found it difficult to relax",
        "I felt down-hearted and blue",
        "I was intolerant of anything that kept me from getting on with what I was doing",
        "I felt I was close to panic",
        "I was unable to become enthusiastic about anything",
        "I felt I wasn't worth much as a person",
        "I felt that I was rather touchy",
        "I was aware of the action of my heart in the absence of physical exertion",
        "I felt scared without any good reason",
        "I felt that life was meaningless"
    };
    
    // Question types mapping (D=Depression, A=Anxiety, S=Stress)
    private static final String[] QUESTION_TYPES = {
        "stress", "anxiety", "depression", "anxiety", "depression",
        "stress", "anxiety", "stress", "anxiety", "depression",
        "stress", "stress", "depression", "stress", "anxiety",
        "depression", "depression", "stress", "anxiety", "anxiety",
        "depression"
    };
    
    // DASS-21 scoring multipliers
    private static final int[] DEPRESSION_QUESTIONS = {2, 4, 9, 12, 15, 16, 19, 20};
    private static final int[] ANXIETY_QUESTIONS = {1, 6, 7, 13, 14, 17, 18, 21};
    private static final int[] STRESS_QUESTIONS = {0, 3, 5, 8, 10, 11, 19, 20};
    
    public String[] getQuestions() {
        return QUESTIONS;
    }
    
    public String[] getQuestionTypes() {
        return QUESTION_TYPES;
    }
    
    public int calculateScore(List<Integer> answers, String type) {
        int score = 0;
        
        if (answers == null || answers.size() != 21) {
            return 0;
        }
        
        if ("depression".equals(type)) {
            for (int questionNum : DEPRESSION_QUESTIONS) {
                // Convert to 0-based index
                int index = questionNum - 1;
                if (index >= 0 && index < answers.size()) {
                    Integer answer = answers.get(index);
                    if (answer != null) {
                        score += answer;
                    }
                }
            }
        } else if ("anxiety".equals(type)) {
            for (int questionNum : ANXIETY_QUESTIONS) {
                int index = questionNum - 1;
                if (index >= 0 && index < answers.size()) {
                    Integer answer = answers.get(index);
                    if (answer != null) {
                        score += answer;
                    }
                }
            }
        } else if ("stress".equals(type)) {
            for (int questionNum : STRESS_QUESTIONS) {
                int index = questionNum - 1;
                if (index >= 0 && index < answers.size()) {
                    Integer answer = answers.get(index);
                    if (answer != null) {
                        score += answer;
                    }
                }
            }
        }
        
        // Multiply by 2 for DASS-21 (convert from 0-3 scale to 0-42 scale)
        return score * 2;
    }
    
    public String determineSeverity(int score, String type) {
        if (type.equals("depression")) {
            if (score <= 9) return "Normal";
            else if (score <= 13) return "Mild";
            else if (score <= 20) return "Moderate";
            else if (score <= 27) return "Severe";
            else return "Extremely Severe";
        } else if (type.equals("anxiety")) {
            if (score <= 7) return "Normal";
            else if (score <= 9) return "Mild";
            else if (score <= 14) return "Moderate";
            else if (score <= 19) return "Severe";
            else return "Extremely Severe";
        } else { // stress
            if (score <= 14) return "Normal";
            else if (score <= 18) return "Mild";
            else if (score <= 25) return "Moderate";
            else if (score <= 33) return "Severe";
            else return "Extremely Severe";
        }
    }
    
    public String determineOverallSeverity(int depressionScore, int anxietyScore, int stressScore) {
        // Take the highest severity
        String depSev = determineSeverity(depressionScore, "depression");
        String anxSev = determineSeverity(anxietyScore, "anxiety");
        String strSev = determineSeverity(stressScore, "stress");
        
        // Convert to numeric values for comparison
        int depLevel = getSeverityLevel(depSev);
        int anxLevel = getSeverityLevel(anxSev);
        int strLevel = getSeverityLevel(strSev);
        
        int maxLevel = Math.max(depLevel, Math.max(anxLevel, strLevel));
        
        return getSeverityFromLevel(maxLevel);
    }
    
    private int getSeverityLevel(String severity) {
        if (severity == null) return 0;
        
        switch (severity) {
            case "Extremely Severe": return 5;
            case "Severe": return 4;
            case "Moderate": return 3;
            case "Mild": return 2;
            case "Normal": return 1;
            default: return 0;
        }
    }
    
    private String getSeverityFromLevel(int level) {
        switch (level) {
            case 5: return "Extremely Severe";
            case 4: return "Severe";
            case 3: return "Moderate";
            case 2: return "Mild";
            case 1: return "Normal";
            default: return "Normal";
        }
    }
    
   public DassAssessment saveAssessment(DassAssessment assessment, List<Integer> answers, Integer userId) {
    System.out.println("DEBUG [DassAssessmentService.saveAssessment]: Starting...");
    
    // Calculate scores
    int depressionScore = calculateScore(answers, "depression");
    int anxietyScore = calculateScore(answers, "anxiety");
    int stressScore = calculateScore(answers, "stress");
    
    // Determine severities
    String depressionSeverity = determineSeverity(depressionScore, "depression");
    String anxietySeverity = determineSeverity(anxietyScore, "anxiety");
    String stressSeverity = determineSeverity(stressScore, "stress");
    String overallSeverity = determineOverallSeverity(depressionScore, anxietyScore, stressScore);
    
    // Set assessment properties
    assessment.setDepressionScore(depressionScore);
    assessment.setAnxietyScore(anxietyScore);
    assessment.setStressScore(stressScore);
    assessment.setDepressionSeverity(depressionSeverity);
    assessment.setAnxietySeverity(anxietySeverity);
    assessment.setStressSeverity(stressSeverity);
    assessment.setOverallSeverity(overallSeverity);
    assessment.setUserId(userId);
    assessment.setCompleted(true);
    
    // Save to database
    Integer assessmentId = dassAssessmentDAO.createAssessment(assessment);
    
    if (assessmentId != null) {
        assessment.setAssessmentId(assessmentId);
        
        // Save answers to database
        List<DassAnswer> dassAnswers = new ArrayList<>();
        for (int i = 0; i < answers.size(); i++) {
            DassAnswer answer = new DassAnswer();
            answer.setAssessmentId(assessmentId);
            answer.setQuestionNumber(i + 1);
            answer.setAnswerValue(answers.get(i));
            answer.setQuestionType(getQuestionTypes()[i]);
            dassAnswers.add(answer);
        }
        
        boolean answersSaved = dassAssessmentDAO.saveAnswers(assessmentId, dassAnswers);
        System.out.println("DEBUG: Answers saved to database: " + answersSaved);
        
        return assessment;
    }
    
    return null;
}
    public Map<String, Object> validateAndProcessAnswers(List<Integer> answers) {
        Map<String, Object> result = new HashMap<>();
        
        if (answers == null || answers.size() != 21) {
            result.put("valid", false);
            result.put("error", "Invalid number of answers. Expected 21, got " + (answers != null ? answers.size() : "null"));
            return result;
        }
        
        // Validate each answer
        List<String> validationErrors = new ArrayList<>();
        int answeredCount = 0;
        
        for (int i = 0; i < answers.size(); i++) {
            Integer answer = answers.get(i);
            if (answer == null) {
                // Null is allowed for unanswered questions
                continue;
            } else if (answer < 0 || answer > 3) {
                validationErrors.add("Question " + (i + 1) + " has invalid value: " + answer);
            } else {
                answeredCount++;
            }
        }
        
        if (!validationErrors.isEmpty()) {
            result.put("valid", false);
            result.put("errors", validationErrors);
            return result;
        }
        
        // Calculate scores for answered questions
        int depressionScore = calculateScore(answers, "depression");
        int anxietyScore = calculateScore(answers, "anxiety");
        int stressScore = calculateScore(answers, "stress");
        
        // Determine severities
        String depressionSeverity = determineSeverity(depressionScore, "depression");
        String anxietySeverity = determineSeverity(anxietyScore, "anxiety");
        String stressSeverity = determineSeverity(stressScore, "stress");
        String overallSeverity = determineOverallSeverity(depressionScore, anxietyScore, stressScore);
        
        result.put("valid", true);
        result.put("answeredCount", answeredCount);
        result.put("depressionScore", depressionScore);
        result.put("anxietyScore", anxietyScore);
        result.put("stressScore", stressScore);
        result.put("depressionSeverity", depressionSeverity);
        result.put("anxietySeverity", anxietySeverity);
        result.put("stressSeverity", stressSeverity);
        result.put("overallSeverity", overallSeverity);
        
        return result;
    }
    
    public List<String> getProgressRecommendations(List<Integer> answers) {
        List<String> recommendations = new ArrayList<>();
        
        if (answers == null || answers.size() != 21) {
            recommendations.add("Please complete all questions for accurate results.");
            return recommendations;
        }
        
        // Calculate partial scores
        int answeredCount = (int) answers.stream().filter(a -> a != null).count();
        int totalQuestions = answers.size();
        int progressPercentage = (answeredCount * 100) / totalQuestions;
        
        recommendations.add("You have completed " + answeredCount + " out of " + totalQuestions + " questions (" + progressPercentage + "%)");
        
        if (progressPercentage == 0) {
            recommendations.add("Get started by answering the first question above.");
        } else if (progressPercentage < 25) {
            recommendations.add("You're just getting started! Keep going to get accurate results.");
            recommendations.add("Try to answer a few more questions to see your initial scores.");
        } else if (progressPercentage < 50) {
            recommendations.add("Great progress! You're almost halfway through.");
            recommendations.add("Your partial results are starting to take shape.");
        } else if (progressPercentage < 75) {
            recommendations.add("More than halfway there! Your results are becoming clearer.");
            recommendations.add("Just a few more questions to get a complete picture.");
        } else if (progressPercentage < 100) {
            recommendations.add("Almost done! Just a few more questions to go.");
            recommendations.add("Complete all questions to get your final assessment results.");
        } else {
            recommendations.add("All questions answered! Ready to submit.");
            recommendations.add("Click 'Submit Assessment' to view your results.");
        }
        
        // If at least some questions are answered, show partial insights
        if (answeredCount > 0 && answeredCount < totalQuestions) {
            Map<String, Object> validation = validateAndProcessAnswers(answers);
            if ((boolean) validation.get("valid")) {
                int depressionScore = (int) validation.get("depressionScore");
                int anxietyScore = (int) validation.get("anxietyScore");
                int stressScore = (int) validation.get("stressScore");
                
                recommendations.add("Current scores (partial): Depression: " + depressionScore + 
                                  ", Anxiety: " + anxietyScore + ", Stress: " + stressScore);
            }
        }
        
        return recommendations;
    }
    
    public List<DassAssessment> getAssessmentsByUser(int userId) {
        return dassAssessmentDAO.getAssessmentsByUserId(userId);
    }
    
    public List<DassAssessment> getAllAssessments() {
        return dassAssessmentDAO.getAllAssessments();
    }
    
    public DassAssessment getAssessmentById(int assessmentId) {
        return dassAssessmentDAO.getAssessmentById(assessmentId);
    }
    
    public boolean deleteAssessment(int assessmentId, Integer userId) {
        return dassAssessmentDAO.deleteAssessment(assessmentId, userId);
    }
    
    public List<DassAssessment> searchAssessments(String searchTerm, String severity) {
        return dassAssessmentDAO.searchAssessments(searchTerm, severity);
    }
    
    public Map<String, Double> getAverageScores() {
        return dassAssessmentDAO.getAverageScores();
    }
    
    public Map<String, Integer> getSeverityDistribution() {
        return dassAssessmentDAO.getSeverityDistribution();
    }
    
    public List<Map<String, Object>> getAssessmentHistory(int assessmentId) {
        return dassAssessmentDAO.getAssessmentHistory(assessmentId);
    }
}