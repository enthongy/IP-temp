package smilespace.controller.selfAssessment;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import smilespace.dao.DassAssessmentDAO;
import smilespace.model.DassAnswer;
import smilespace.model.DassAssessment;
import smilespace.service.DassAssessmentService;

@Controller
@RequestMapping("/self-assessment")
public class SelfAssessmentController {
    
    @Autowired
    private DassAssessmentService dassAssessmentService;
    
    @Autowired
    private DassAssessmentDAO dassAssessmentDAO; 
    // DASS-21 questions
    
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
    
    // Show assessment form
    @GetMapping("")
    public String showAssessmentForm(Model model, HttpSession session) {
        System.out.println("DEBUG [SelfAssessmentController.showAssessmentForm]: Starting...");
        
        // Check if user is logged in
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            System.out.println("DEBUG: User not logged in, redirecting to login");
            return "redirect:/login?redirect=/self-assessment";
        }
        
        Integer userId = (Integer) userIdObj;
        System.out.println("DEBUG: Showing assessment form for user ID: " + userId);
        
        // Get questions from service
        String[] questions = dassAssessmentService.getQuestions();
        
        model.addAttribute("questions", questions);
        model.addAttribute("totalQuestions", questions.length);
        
        System.out.println("DEBUG: Loaded " + questions.length + " questions");
        
        return "selfAssessmentModule/assessment";
    }
@PostMapping("/submit")
public String submitAssessment(
        @RequestParam(value = "answersJson", required = false) String answersJson,
        HttpServletRequest request,
        HttpSession session,
        RedirectAttributes redirectAttributes) {
    
    System.out.println("DEBUG: === Assessment Submission Started ===");
    
    // Get user ID from session
    Integer userId = getUserIdFromSession(session);
    System.out.println("DEBUG: User ID from session: " + userId);
    
    if (userId == null) {
        System.out.println("DEBUG: No user ID found, redirecting to login");
        return "redirect:/login";
    }
    
    List<Integer> answers = new ArrayList<>();
    
    // FIRST: Try to get answers from JSON
    if (answersJson != null && !answersJson.isEmpty()) {
        System.out.println("DEBUG: JSON provided: " + answersJson);
        try {
            Gson gson = new Gson();
            Type listType = new TypeToken<List<Integer>>(){}.getType();
            answers = gson.fromJson(answersJson, listType);
            System.out.println("DEBUG: Parsed JSON answers. Size: " + (answers != null ? answers.size() : "null"));
        } catch (Exception e) {
            System.err.println("ERROR: Failed to parse JSON answers: " + e.getMessage());
            e.printStackTrace();
            answers = new ArrayList<>();
        }
    }
    
    // SECOND: If JSON parsing failed or gave null, try individual parameters
    if (answers == null || answers.isEmpty() || answers.size() != 21) {
        System.out.println("DEBUG: Checking individual parameters...");
        answers = new ArrayList<>();
        for (int i = 0; i < 21; i++) {
            String answerValue = request.getParameter("answer" + i);
            String hiddenAnswer = request.getParameter("hiddenAnswer" + i);
            
            System.out.println("DEBUG: answer" + i + " = " + answerValue + ", hiddenAnswer" + i + " = " + hiddenAnswer);
            
            // Try answer first, then hidden answer
            if (answerValue != null && !answerValue.trim().isEmpty()) {
                try {
                    int value = Integer.parseInt(answerValue.trim());
                    if (value >= 0 && value <= 3) {
                        answers.add(value);
                    } else {
                        System.err.println("ERROR: Invalid answer for question " + (i+1) + ": " + value);
                        redirectAttributes.addFlashAttribute("error", "Invalid answer for question " + (i+1));
                        return "redirect:/self-assessment";
                    }
                } catch (NumberFormatException e) {
                    System.err.println("ERROR: Invalid answer format for question " + (i+1));
                    redirectAttributes.addFlashAttribute("error", "Invalid answer format for question " + (i+1));
                    return "redirect:/self-assessment";
                }
            } else if (hiddenAnswer != null && !hiddenAnswer.trim().isEmpty()) {
                try {
                    int value = Integer.parseInt(hiddenAnswer.trim());
                    if (value >= 0 && value <= 3) {
                        answers.add(value);
                    } else {
                        System.err.println("ERROR: Invalid hidden answer for question " + (i+1));
                        redirectAttributes.addFlashAttribute("error", "Please answer question " + (i+1));
                        return "redirect:/self-assessment";
                    }
                } catch (NumberFormatException e) {
                    System.err.println("ERROR: Invalid hidden answer format for question " + (i+1));
                    redirectAttributes.addFlashAttribute("error", "Please answer question " + (i+1));
                    return "redirect:/self-assessment";
                }
            } else {
                System.err.println("ERROR: Missing answer for question " + (i+1));
                redirectAttributes.addFlashAttribute("error", "Please answer all 21 questions. Missing question " + (i+1));
                return "redirect:/self-assessment";
            }
        }
    }
    
    System.out.println("DEBUG: Final answers: " + answers);
    System.out.println("DEBUG: Answers size: " + answers.size());
    
    // Validate we have 21 answers
    if (answers.size() != 21) {
        System.err.println("ERROR: Wrong number of answers. Expected 21, got: " + answers.size());
        redirectAttributes.addFlashAttribute("error", "Please answer all 21 questions.");
        return "redirect:/self-assessment";
    }
    
    // Validate all answers are between 0-3
    for (int i = 0; i < answers.size(); i++) {
        Integer answer = answers.get(i);
        if (answer == null || answer < 0 || answer > 3) {
            System.err.println("ERROR: Invalid answer value for question " + (i+1) + ": " + answer);
            redirectAttributes.addFlashAttribute("error", "Invalid answer for question " + (i+1));
            return "redirect:/self-assessment";
        }
    }
    
    try {
        // Create assessment object
        DassAssessment assessment = new DassAssessment();
        assessment.setAssessmentDate(new Date());
        assessment.setUserId(userId);
        
        // Save assessment using service method
        System.out.println("DEBUG: Saving assessment via service...");
        DassAssessment savedAssessment = dassAssessmentService.saveAssessment(assessment, answers, userId);
        
        if (savedAssessment != null && savedAssessment.getAssessmentId() > 0) {
            System.out.println("DEBUG: Assessment saved successfully. ID: " + savedAssessment.getAssessmentId());
            
            // Store in session for immediate access
            session.setAttribute("lastAssessmentId", savedAssessment.getAssessmentId());
            
            // Store assessment data in session for result page
            Map<String, Object> assessmentData = new HashMap<>();
            assessmentData.put("assessmentId", savedAssessment.getAssessmentId());
            assessmentData.put("depressionScore", savedAssessment.getDepressionScore());
            assessmentData.put("anxietyScore", savedAssessment.getAnxietyScore());
            assessmentData.put("stressScore", savedAssessment.getStressScore());
            assessmentData.put("overallSeverity", savedAssessment.getOverallSeverity());
            session.setAttribute("currentAssessmentData", assessmentData);
            
            // Clear any saved progress from session
            session.removeAttribute("assessmentProgress");
            session.removeAttribute("currentQuestion");
            
            // Store individual answers in session (optional, for debugging)
            session.setAttribute("answersData", answers);
            
            // REMOVED: Don't call saveAnswersToDatabase() here
            // The service.saveAssessment() method should already save answers
            // If it doesn't, fix the service method instead
            
            // Redirect to result page
            System.out.println("DEBUG: Redirecting to result page for assessment ID: " + savedAssessment.getAssessmentId());
            return "redirect:/self-assessment/result/" + savedAssessment.getAssessmentId();
        } else {
            System.err.println("ERROR: Failed to save assessment");
            redirectAttributes.addFlashAttribute("error", "Failed to save assessment. Please try again.");
            return "redirect:/self-assessment";
        }
    } catch (Exception e) {
        System.err.println("ERROR: Exception during assessment save: " + e.getMessage());
        e.printStackTrace();
        redirectAttributes.addFlashAttribute("error", "An error occurred: " + e.getMessage());
        return "redirect:/self-assessment";
    }
}

// Add this helper method to save answers
private boolean saveAnswersToDatabase(int assessmentId, List<Integer> answers) {
    try {
        List<DassAnswer> dassAnswers = new ArrayList<>();
        String[] questionTypes = dassAssessmentService.getQuestionTypes();
        
        for (int i = 0; i < answers.size(); i++) {
            DassAnswer answer = new DassAnswer();
            answer.setAssessmentId(assessmentId);
            answer.setQuestionNumber(i + 1); // 1-based index
            answer.setAnswerValue(answers.get(i));
            answer.setQuestionType(questionTypes[i]);
            dassAnswers.add(answer);
        }
        
        return dassAssessmentDAO.saveAnswers(assessmentId, dassAnswers);
    } catch (Exception e) {
        System.err.println("ERROR saving answers to database: " + e.getMessage());
        return false;
    }
}

// Simple test endpoint to check if form is reaching controller
@PostMapping("/test-submit")
@ResponseBody
public String testSubmit(HttpServletRequest request) {
    System.out.println("DEBUG: Test submit reached!");
    
    for (int i = 0; i < 21; i++) {
        String answer = request.getParameter("answer" + i);
        System.out.println("answer" + i + " = " + answer);
    }
    
    String json = request.getParameter("answersJson");
    System.out.println("answersJson = " + json);
    
    return "Form data received successfully!";
}

    // Auto-save progress endpoint
    @PostMapping("/autosave")
    @ResponseBody
    public Map<String, Object> autoSaveProgress(
            @RequestBody Map<String, Object> requestData,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        Integer userId = getUserIdFromSession(session);
        
        if (userId == null) {
            response.put("success", false);
            response.put("error", "Not logged in");
            return response;
        }
        
        try {
            @SuppressWarnings("unchecked")
            List<Integer> answers = (List<Integer>) requestData.get("answers");
            Integer currentQuestion = (Integer) requestData.get("currentQuestion");
            
            if (answers != null && answers.size() == 21) {
                // Validate answers
                int answeredCount = 0;
                boolean allValid = true;
                List<String> validationErrors = new ArrayList<>();
                
                for (int i = 0; i < answers.size(); i++) {
                    Integer answer = answers.get(i);
                    if (answer != null) {
                        if (answer >= 0 && answer <= 3) {
                            answeredCount++;
                        } else {
                            allValid = false;
                            validationErrors.add("Question " + (i + 1) + " has invalid value: " + answer);
                        }
                    }
                }
                
                if (!allValid) {
                    response.put("success", false);
                    response.put("error", "Invalid answers");
                    response.put("validationErrors", validationErrors);
                    return response;
                }
                
                // Store progress in session
                session.setAttribute("assessmentProgress", answers);
                session.setAttribute("currentQuestion", currentQuestion);
                session.setAttribute("progressTimestamp", new Date().getTime());
                
                // Calculate progress percentage
                int progressPercentage = (answeredCount * 100) / answers.size();
                
                // Generate progress message
                String progressMessage = getProgressMessage(answeredCount, answers.size());
                
                response.put("success", true);
                response.put("answeredCount", answeredCount);
                response.put("totalQuestions", answers.size());
                response.put("progressPercentage", progressPercentage);
                response.put("progressMessage", progressMessage);
                response.put("timestamp", new Date().getTime());
                response.put("currentQuestion", currentQuestion);
                
                System.out.println("DEBUG: Auto-saved progress for user " + userId + 
                                 ": " + answeredCount + "/" + answers.size() + " questions answered");
                
            } else {
                response.put("success", false);
                response.put("error", "Invalid data format");
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in autoSaveProgress: " + e.getMessage());
            response.put("success", false);
            response.put("error", e.getMessage());
        }
        
        return response;
    }
    
    // Get progress message based on completion
    private String getProgressMessage(int answeredCount, int totalQuestions) {
        int percentage = (answeredCount * 100) / totalQuestions;
        
        if (percentage == 0) {
            return "Get started by answering the first question";
        } else if (percentage < 25) {
            return "You're just getting started!";
        } else if (percentage < 50) {
            return "Great progress! Keep going.";
        } else if (percentage < 75) {
            return "More than halfway there!";
        } else if (percentage < 100) {
            return "Almost done! Just a few more questions.";
        } else {
            return "All questions answered! Ready to submit.";
        }
    }
    
    // View assessment result
    @GetMapping("/result/{id}")
    public String viewResult(
            @PathVariable("id") Integer assessmentId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        System.out.println("DEBUG [SelfAssessmentController.viewResult]: Viewing result for assessment ID: " + assessmentId);
        
        // Get user ID from session
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            System.out.println("DEBUG: No user ID in session, redirecting to login");
            return "redirect:/login";
        }
        
        DassAssessment assessment = dassAssessmentService.getAssessmentById(assessmentId);
        
        if (assessment != null) {
            System.out.println("DEBUG: Assessment found. User ID in assessment: " + assessment.getUserId());
            System.out.println("DEBUG: Current user ID: " + userId);
            
            // Check authorization - user can only view their own results unless they're professional
            String userRole = (String) session.getAttribute("userRole");
            System.out.println("DEBUG: User role: " + userRole);
            
            boolean isAuthorized = false;
            if (userId.equals(assessment.getUserId())) {
                isAuthorized = true;
                System.out.println("DEBUG: User is viewing their own assessment");
            } else if ("professional".equals(userRole) || "admin".equals(userRole) || "faculty".equals(userRole)) {
                isAuthorized = true;
                System.out.println("DEBUG: Professional/admin/faculty viewing student assessment");
            }
            
            if (!isAuthorized) {
                System.err.println("ERROR: Unauthorized access attempt");
                return "redirect:/dashboard?error=unauthorized";
            }
            
            model.addAttribute("assessment", assessment);
            System.out.println("DEBUG: Assessment added to model: " + assessment.getAssessmentId());
            
            // Get personalized recommendations based on scores
            List<String> recommendations = getPersonalizedRecommendations(assessment);
            model.addAttribute("recommendations", recommendations);
            System.out.println("DEBUG: Generated " + recommendations.size() + " recommendations");
            
            // Get user's previous assessments for history
            List<DassAssessment> previousAssessments = dassAssessmentService.getAssessmentsByUser(assessment.getUserId());
            // Remove current assessment from the list
            previousAssessments.removeIf(a -> a.getAssessmentId() == assessmentId);
            model.addAttribute("previousAssessments", previousAssessments);
            System.out.println("DEBUG: Loaded " + previousAssessments.size() + " previous assessments");
            
            // Clear any saved progress from session
            session.removeAttribute("assessmentProgress");
            session.removeAttribute("currentQuestion");
            session.removeAttribute("currentAssessmentData");
            
            return "selfAssessmentModule/viewResult";
        } else {
            System.err.println("ERROR: Assessment not found for ID: " + assessmentId);
            
            // Try to get last assessment from session
            Integer lastAssessmentId = (Integer) session.getAttribute("lastAssessmentId");
            if (lastAssessmentId != null) {
                System.out.println("DEBUG: Trying last assessment ID from session: " + lastAssessmentId);
                redirectAttributes.addFlashAttribute("error", "Assessment not found. Redirecting to your last assessment.");
                return "redirect:/self-assessment/result/" + lastAssessmentId;
            }
            
            redirectAttributes.addFlashAttribute("error", "Assessment not found. Please take the assessment again.");
            return "redirect:/self-assessment";
        }
    }
    
    // Direct result access (for after submission)
    @GetMapping("/result")
    public String viewLatestResult(
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        System.out.println("DEBUG: Accessing latest result");
        
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Check if we have assessment data in session (just completed)
        @SuppressWarnings("unchecked")
        Map<String, Object> assessmentData = (Map<String, Object>) session.getAttribute("currentAssessmentData");
        if (assessmentData != null) {
            Integer assessmentId = (Integer) assessmentData.get("assessmentId");
            System.out.println("DEBUG: Found assessment data in session, redirecting to ID: " + assessmentId);
            return "redirect:/self-assessment/result/" + assessmentId;
        }
        
        // Get user's assessments from database
        List<DassAssessment> assessments = dassAssessmentService.getAssessmentsByUser(userId);
        
        if (!assessments.isEmpty()) {
            // Redirect to latest assessment
            Integer latestId = assessments.get(0).getAssessmentId();
            System.out.println("DEBUG: Redirecting to latest assessment ID: " + latestId);
            return "redirect:/self-assessment/result/" + latestId;
        } else {
            redirectAttributes.addFlashAttribute("error", "No assessments found. Please take an assessment first.");
            return "redirect:/self-assessment";
        }
    }
    
    // Assessment management (for professionals only)
    @GetMapping("/manage")
    public String manageAssessments(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String severity,
            Model model,
            HttpSession session) {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"professional".equals(userRole) && !"admin".equals(userRole) && !"faculty".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        // Get assessments based on filters
        List<DassAssessment> assessments;
        if ((search != null && !search.trim().isEmpty()) || 
            (severity != null && !severity.trim().isEmpty() && !"All Severities".equals(severity))) {
            assessments = dassAssessmentService.searchAssessments(
                search != null ? search.trim() : null,
                severity != null ? severity.trim() : null
            );
        } else {
            assessments = dassAssessmentService.getAllAssessments();
        }
        
        // Get statistics
        Map<String, Double> averageScores = dassAssessmentService.getAverageScores();
        Map<String, Integer> severityDistribution = dassAssessmentService.getSeverityDistribution();
        
        model.addAttribute("assessments", assessments);
        model.addAttribute("averageScores", averageScores);
        model.addAttribute("severityDistribution", severityDistribution);
        model.addAttribute("search", search);
        model.addAttribute("severity", severity);
        
        return "selfAssessmentModule/assessmentManagement";
    }
    
    // Delete assessment (professionals only)
    @PostMapping("/delete")
    public String deleteAssessment(
            @RequestParam Integer assessmentId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"professional".equals(userRole) && !"admin".equals(userRole) && !"faculty".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        Integer userId = getUserIdFromSession(session);
        
        boolean success = dassAssessmentService.deleteAssessment(assessmentId, userId);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Assessment deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to delete assessment");
        }
        
        return "redirect:/self-assessment/manage";
    }
    
    // View assessment details
    @GetMapping("/details/{id}")
    public String viewAssessmentDetails(
            @PathVariable("id") Integer assessmentId,
            Model model,
            HttpSession session) {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"professional".equals(userRole) && !"admin".equals(userRole) && !"faculty".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        DassAssessment assessment = dassAssessmentService.getAssessmentById(assessmentId);
        
        if (assessment != null) {
            model.addAttribute("assessment", assessment);
            return "selfAssessmentModule/assessmentDetails";
        } else {
            return "redirect:/self-assessment/manage?error=assessment_not_found";
        }
    }
    
    // Get assessment details (AJAX endpoint)
    @GetMapping("/details/{id}/ajax")
    @ResponseBody
    public Map<String, Object> getAssessmentDetailsAjax(
            @PathVariable("id") Integer assessmentId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"professional".equals(userRole) && !"admin".equals(userRole) && !"faculty".equals(userRole)) {
            response.put("error", "Unauthorized");
            return response;
        }
        
        DassAssessment assessment = dassAssessmentService.getAssessmentById(assessmentId);
        
        if (assessment != null) {
            response.put("success", true);
            response.put("assessmentId", assessment.getAssessmentId());
            response.put("depressionScore", assessment.getDepressionScore());
            response.put("depressionSeverity", assessment.getDepressionSeverity());
            response.put("anxietyScore", assessment.getAnxietyScore());
            response.put("anxietySeverity", assessment.getAnxietySeverity());
            response.put("stressScore", assessment.getStressScore());
            response.put("stressSeverity", assessment.getStressSeverity());
            response.put("overallSeverity", assessment.getOverallSeverity());
            response.put("userFullName", assessment.getUserFullName());
            response.put("userName", assessment.getUserName());
            response.put("assessmentDate", assessment.getAssessmentDate());
        } else {
            response.put("error", "Assessment not found");
        }
        
        return response;
    }
    
    // View assessment history
    @GetMapping("/history/{id}")
    public String viewAssessmentHistory(
            @PathVariable("id") Integer assessmentId,
            Model model,
            HttpSession session) {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"professional".equals(userRole) && !"admin".equals(userRole) && !"faculty".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        List<Map<String, Object>> history = dassAssessmentService.getAssessmentHistory(assessmentId);
        DassAssessment assessment = dassAssessmentService.getAssessmentById(assessmentId);
        
        model.addAttribute("history", history);
        model.addAttribute("assessment", assessment);
        
        return "selfAssessmentModule/assessmentHistory";
    }
    
    // Get previous assessments for a user
    @GetMapping("/user/{userId}/history")
    @ResponseBody
    public List<DassAssessment> getUserAssessmentHistory(
            @PathVariable("userId") Integer userId,
            HttpSession session) {
        
        // Authorization check
        Integer currentUserId = getUserIdFromSession(session);
        String userRole = (String) session.getAttribute("userRole");
        
        // Users can only view their own history unless they're professionals
        if (currentUserId == null || 
            (!currentUserId.equals(userId) && 
             !"professional".equals(userRole) && 
             !"admin".equals(userRole) && 
             !"faculty".equals(userRole))) {
            return new ArrayList<>();
        }
        
        return dassAssessmentService.getAssessmentsByUser(userId);
    }
    
    // Export CSV report
    @GetMapping("/export/csv")
    public void exportCSVReport(
            HttpServletResponse response,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String severity,
            HttpSession session) throws IOException {
        
        // Authorization check
        String userRole = (String) session.getAttribute("userRole");
        if (!"professional".equals(userRole) && !"admin".equals(userRole) && !"faculty".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        // Get assessments based on filters
        List<DassAssessment> assessments;
        if ((search != null && !search.trim().isEmpty()) || 
            (severity != null && !severity.trim().isEmpty())) {
            assessments = dassAssessmentService.searchAssessments(
                search != null ? search.trim() : null,
                severity != null ? severity.trim() : null
            );
        } else {
            assessments = dassAssessmentService.getAllAssessments();
        }
        
        // Set response headers for CSV download
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String filename = "dass_assessment_report_" + timestamp + ".csv";
        
        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        
        // Write CSV content
        PrintWriter writer = response.getWriter();
        
        // CSV header
        writer.println("Assessment ID,Student Name,Username,Date,Depression Score,Depression Severity," +
                      "Anxiety Score,Anxiety Severity,Stress Score,Stress Severity,Overall Severity");
        
        // CSV data
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (DassAssessment assessment : assessments) {
            writer.print(assessment.getAssessmentId() + ",");
            writer.print(escapeCSV(assessment.getUserFullName() != null ? assessment.getUserFullName() : 
                assessment.getUserName() != null ? assessment.getUserName() : "Unknown") + ",");
            writer.print(escapeCSV(assessment.getUserName() != null ? assessment.getUserName() : "") + ",");
            writer.print(assessment.getAssessmentDate() != null ? 
                dateFormat.format(assessment.getAssessmentDate()) : "" + ",");
            writer.print(assessment.getDepressionScore() + ",");
            writer.print(escapeCSV(assessment.getDepressionSeverity()) + ",");
            writer.print(assessment.getAnxietyScore() + ",");
            writer.print(escapeCSV(assessment.getAnxietySeverity()) + ",");
            writer.print(assessment.getStressScore() + ",");
            writer.print(escapeCSV(assessment.getStressSeverity()) + ",");
            writer.print(escapeCSV(assessment.getOverallSeverity()));
            writer.println();
        }
        
        writer.flush();
        writer.close();
    }
    
    // Get user's own assessment history (for students)
    @GetMapping("/my-history")
    public String viewMyAssessmentHistory(
            Model model,
            HttpSession session) {
        
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        List<DassAssessment> myAssessments = dassAssessmentService.getAssessmentsByUser(userId);
        model.addAttribute("assessments", myAssessments);
        
        return "selfAssessmentModule/myAssessmentHistory";
    }
    
    // Quick stats for dashboard (AJAX endpoint)
    @GetMapping("/quick-stats")
    @ResponseBody
    public Map<String, Object> getQuickStats(HttpSession session) {
        Map<String, Object> stats = new HashMap<>();
        
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            stats.put("error", "Not logged in");
            return stats;
        }
        
        // Get user's assessments
        List<DassAssessment> userAssessments = dassAssessmentService.getAssessmentsByUser(userId);
        
        if (!userAssessments.isEmpty()) {
            DassAssessment latest = userAssessments.get(0);
            stats.put("latestAssessment", latest);
            stats.put("totalAssessments", userAssessments.size());
            
            // Calculate trends if there are multiple assessments
            if (userAssessments.size() > 1) {
                DassAssessment previous = userAssessments.size() > 1 ? userAssessments.get(1) : null;
                if (previous != null) {
                    Map<String, String> trends = new HashMap<>();
                    
                    // Depression trend
                    int depDiff = latest.getDepressionScore() - previous.getDepressionScore();
                    trends.put("depression", depDiff > 0 ? "increased" : depDiff < 0 ? "decreased" : "unchanged");
                    
                    // Anxiety trend
                    int anxDiff = latest.getAnxietyScore() - previous.getAnxietyScore();
                    trends.put("anxiety", anxDiff > 0 ? "increased" : anxDiff < 0 ? "decreased" : "unchanged");
                    
                    // Stress trend
                    int strDiff = latest.getStressScore() - previous.getStressScore();
                    trends.put("stress", strDiff > 0 ? "increased" : strDiff < 0 ? "decreased" : "unchanged");
                    
                    stats.put("trends", trends);
                }
            }
        } else {
            stats.put("message", "No assessments yet");
        }
        
        return stats;
    }
    
    // Resume assessment endpoint
    @GetMapping("/resume")
    public String resumeAssessment(HttpSession session, RedirectAttributes redirectAttributes) {
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Check if there's progress in session
        @SuppressWarnings("unchecked")
        List<Integer> progress = (List<Integer>) session.getAttribute("assessmentProgress");
        Integer currentQuestion = (Integer) session.getAttribute("currentQuestion");
        
        if (progress != null && currentQuestion != null) {
            redirectAttributes.addFlashAttribute("resumeProgress", true);
            redirectAttributes.addFlashAttribute("currentQuestion", currentQuestion);
            redirectAttributes.addFlashAttribute("answeredCount", 
                progress.stream().filter(a -> a != null).count());
        }
        
        return "redirect:/self-assessment";
    }
    
    // Clear saved progress
    @PostMapping("/clear-progress")
    @ResponseBody
    public Map<String, Object> clearProgress(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        session.removeAttribute("assessmentProgress");
        session.removeAttribute("currentQuestion");
        session.removeAttribute("progressTimestamp");
        
        response.put("success", true);
        response.put("message", "Progress cleared");
        
        return response;
    }
    
    // Helper methods
    private Integer getUserIdFromSession(HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return null;
        }
        
        if (userIdObj instanceof Integer) {
            return (Integer) userIdObj;
        } else if (userIdObj instanceof String) {
            try {
                return Integer.parseInt((String) userIdObj);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }
    
    private List<String> getPersonalizedRecommendations(DassAssessment assessment) {
        List<String> recommendations = new ArrayList<>();
        
        // Based on depression score
        if (assessment.getDepressionScore() >= 28) { // Extremely severe
            recommendations.add("Your depression score indicates extremely severe symptoms. It's important to seek professional help immediately. Consider contacting campus counseling services or a mental health professional.");
        } else if (assessment.getDepressionScore() >= 21) { // Severe
            recommendations.add("Your depression score suggests severe symptoms that may be affecting your daily life. We recommend scheduling an appointment with a mental health professional for support.");
        } else if (assessment.getDepressionScore() >= 14) { // Moderate
            recommendations.add("You're experiencing moderate depression symptoms. Consider talking to a counselor and exploring our mindfulness and relaxation modules.");
        } else if (assessment.getDepressionScore() >= 10) { // Mild
            recommendations.add("You have mild depression symptoms. Try engaging in regular physical activity and maintaining social connections.");
        } else {
            recommendations.add("Your depression score is in the normal range. Continue practicing good mental health habits.");
        }
        
        // Based on anxiety score
        if (assessment.getAnxietyScore() >= 20) { // Extremely severe
            recommendations.add("Your anxiety score indicates extremely severe symptoms. Please seek professional support immediately. Practice deep breathing exercises when feeling overwhelmed.");
        } else if (assessment.getAnxietyScore() >= 15) { // Severe
            recommendations.add("You're experiencing severe anxiety. Consider professional support and try the 5-4-3-2-1 grounding technique when feeling anxious.");
        } else if (assessment.getAnxietyScore() >= 10) { // Moderate
            recommendations.add("Moderate anxiety detected. Practice mindfulness meditation daily and consider limiting caffeine intake.");
        } else if (assessment.getAnxietyScore() >= 8) { // Mild
            recommendations.add("Mild anxiety symptoms present. Try progressive muscle relaxation exercises.");
        }
        
        // Based on stress score
        if (assessment.getStressScore() >= 34) { // Extremely severe
            recommendations.add("Extremely severe stress levels detected. It's crucial to implement stress management techniques and seek support. Consider taking a break and prioritizing self-care.");
        } else if (assessment.getStressScore() >= 26) { // Severe
            recommendations.add("You're experiencing severe stress. Implement time management strategies and ensure adequate sleep and nutrition.");
        } else if (assessment.getStressScore() >= 19) { // Moderate
            recommendations.add("Moderate stress levels. Take regular breaks and practice stress-reduction techniques throughout your day.");
        } else if (assessment.getStressScore() >= 15) { // Mild
            recommendations.add("Mild stress detected. Consider incorporating short relaxation breaks into your routine.");
        }
        
        // General recommendations
        recommendations.add("Explore our learning modules for additional support with managing stress, anxiety, and depression.");
        recommendations.add("Consider keeping a mood journal to track patterns and triggers in your emotional well-being.");
        recommendations.add("Connect with campus counseling services or support groups if you need additional help.");
        
        // Limit to 5 recommendations
        return recommendations.size() > 5 ? recommendations.subList(0, 5) : recommendations;
    }
    
    private String escapeCSV(String value) {
        if (value == null) {
            return "";
        }
        String escaped = value.replace("\"", "\"\"");
        if (escaped.contains(",") || escaped.contains("\"") || escaped.contains("\n") || escaped.contains("\r")) {
            return "\"" + escaped + "\"";
        }
        return escaped;
    }
}