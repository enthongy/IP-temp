<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Assessment Results - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #FBF6EA;
            color: #713C0B;
            font-family: 'Fredoka', sans-serif;
            padding-bottom: 40px;
        }

        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 22px 40px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #F0A548;
            text-decoration: none;
        }

        .logo:hover {
            color: #D7923B;
            text-decoration: none;
        }

        .user-menu { 
            position: relative; 
        }
        
        .user-btn {
            background: #D7923B;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            font-size: 20px;
            transition: all 0.3s ease;
        }
        
        .user-btn:hover {
            background: #C77D2F;
            transform: scale(1.05);
        }
        
        .dropdown {
            position: absolute;
            top: 60px;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            min-width: 220px;
            display: none;
            z-index: 1000;
            overflow: hidden;
        }
        
        .dropdown.show { 
            display: block; 
        }
        
        .user-info { 
            padding: 15px; 
            background: #FFF3C8; 
            border-bottom: 2px solid #E8D4B9; 
        }
        
        .user-name { 
            font-weight: bold; 
            font-size: 16px;
        }
        
        .user-role {
            background: #D7923B;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            display: inline-block;
            margin-top: 5px;
        }
        
        .menu-item { 
            padding: 12px 15px; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
            text-decoration: none; 
            color: #6B4F36; 
            border-bottom: 1px solid #eee; 
            transition: background 0.2s;
        }
        
        .menu-item:hover { 
            background: #FFF8E8; 
            text-decoration: none;
        }
        
        .menu-item.logout { 
            color: #E74C3C; 
        }

        .page-title {
            text-align: center;
            margin-top: 30px;
            margin-bottom: 20px;
            padding: 0 20px;
        }

        .page-title h1 {
            color: #F0A548;
            font-size: 36px;
            font-weight: 700;
        }

        .page-title p {
            font-size: 16px;
            color: #A06A2F;
        }

        .results-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .results-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin: 40px 0;
        }

        .result-card {
            background: #FFFFFF;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .result-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .result-card h3 {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 20px;
        }

        .result-score {
            font-size: 48px;
            font-weight: 700;
            color: #713C0B;
            margin: 15px 0;
        }

        .result-severity {
            font-size: 20px;
            font-weight: 600;
            padding: 8px 20px;
            border-radius: 25px;
            display: inline-block;
            margin-bottom: 15px;
        }

        .severity-normal { background: #2ECC71; color: white; }
        .severity-mild { background: #F39C12; color: white; }
        .severity-moderate { background: #E67E22; color: white; }
        .severity-severe { background: #E74C3C; color: white; }
        .severity-extremely-severe { background: #8B0000; color: white; }

        .result-description {
            font-size: 14px;
            color: #A06A2F;
            margin-top: 10px;
            line-height: 1.6;
        }

        .recommendations-section {
            margin: 50px 0;
        }

        .recommendations-section h2 {
            color: #F0A548;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 25px;
            text-align: center;
        }

        .recommendations-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
        }

        .recommendation-card {
            background: #FFFFFF;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        .recommendation-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }

        .recommendation-icon {
            font-size: 32px;
            color: #D7923B;
            margin-bottom: 15px;
        }

        .recommendation-card h3 {
            font-size: 20px;
            font-weight: 600;
            color: #713C0B;
            margin-bottom: 15px;
        }

        .recommendation-card p {
            font-size: 15px;
            color: #A06A2F;
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 40px 0;
            flex-wrap: wrap;
        }

        .btn {
            padding: 14px 30px;
            border-radius: 12px;
            border: none;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-primary {
            background: #F0A548;
            color: white;
        }
        
        .btn-primary:hover {
            background: #D7923B;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        .btn-secondary {
            background: #6B4F36;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5A2F08;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        .btn-success {
            background: #27AE60;
            color: white;
        }
        
        .btn-success:hover {
            background: #219653;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        .history-section {
            background: #FFF3C8;
            padding: 30px;
            border-radius: 15px;
            margin: 40px 0;
            border: 2px solid #F0D5B8;
        }

        .history-section h2 {
            color: #713C0B;
            font-size: 24px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .no-history {
            text-align: center;
            padding: 20px;
            color: #A06A2F;
        }

        .no-history i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .history-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }

        .history-table th {
            background: #F0D5B8;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #713C0B;
        }

        .history-table td {
            padding: 12px;
            border-bottom: 1px solid #F0D5B8;
        }

        .history-table tr:last-child td {
            border-bottom: none;
        }

        .history-table tr:hover {
            background: #FFF9F0;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 20px;
            max-width: 500px;
            width: 90%;
            position: relative;
        }

        .modal-close {
            position: absolute;
            top: 15px;
            right: 15px;
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #713C0B;
        }

        .success-message {
            background: #D4EDDA;
            color: #155724;
            padding: 15px;
            border-radius: 10px;
            margin: 20px auto;
            max-width: 800px;
            border: 1px solid #C3E6CB;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .error-message {
            background: #F8D7DA;
            color: #721c24;
            padding: 15px;
            border-radius: 10px;
            margin: 20px auto;
            max-width: 800px;
            border: 1px solid #F5C6CB;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        @media (max-width: 768px) {
            .top-nav {
                padding: 15px 20px;
            }
            
            .results-section {
                grid-template-columns: 1fr;
            }
            
            .recommendations-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
            
            .history-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/dashboard" class="logo">SmileSpace</a>
        <div class="user-menu">
            <button class="user-btn" id="userBtn">
                <i class="fas fa-user"></i>
            </button>
            <div class="dropdown" id="dropdown">
                <div class="user-info">
                    <div class="user-name">${sessionScope.userFullName}</div>
                    <div class="user-role">${sessionScope.userRole}</div>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <div style="max-width: 1200px; margin: 20px auto; padding: 0 20px;">
        <c:if test="${not empty success}">
            <div class="success-message">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
    </div>

    <div class="page-title">
        <h1>Your Assessment Results</h1>
        <p>
            Completed on 
            <fmt:formatDate value="${assessment.assessmentDate}" pattern="dd MMM yyyy 'at' hh:mm a" />
            • Assessment ID: A${assessment.assessmentId}
        </p>
    </div>

    <div class="results-container">
        <!-- Results Section -->
        <div class="results-section">
            <div class="result-card" id="depressionCard">
                <h3><i class="fas fa-cloud"></i> Depression</h3>
                <div class="result-score">${assessment.depressionScore}</div>
                <div class="result-severity severity-${fn:toLowerCase(fn:replace(assessment.depressionSeverity, ' ', '-'))}">
                    ${assessment.depressionSeverity}
                </div>
                <div class="result-description">
                    <c:choose>
                        <c:when test="${assessment.depressionScore <= 9}">
                            Your depression score is in the normal range. This suggests no significant depression symptoms affecting you.
                        </c:when>
                        <c:when test="${assessment.depressionScore <= 13}">
                            You're experiencing mild depression symptoms. Consider incorporating positive activities into your routine.
                        </c:when>
                        <c:when test="${assessment.depressionScore <= 20}">
                            Your score indicates moderate depression. It might be helpful to speak with a counselor or mental health professional.
                        </c:when>
                        <c:when test="${assessment.depressionScore <= 27}">
                            You're experiencing severe depression symptoms. Professional support is recommended to help manage these symptoms.
                        </c:when>
                        <c:otherwise>
                            Your score indicates extremely severe depression. Please consider seeking immediate professional support.
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="result-card" id="anxietyCard">
                <h3><i class="fas fa-heartbeat"></i> Anxiety</h3>
                <div class="result-score">${assessment.anxietyScore}</div>
                <div class="result-severity severity-${fn:toLowerCase(fn:replace(assessment.anxietySeverity, ' ', '-'))}">
                    ${assessment.anxietySeverity}
                </div>
                <div class="result-description">
                    <c:choose>
                        <c:when test="${assessment.anxietyScore <= 7}">
                            Your anxiety score is in the normal range. You're managing anxiety well.
                        </c:when>
                        <c:when test="${assessment.anxietyScore <= 9}">
                            You have mild anxiety symptoms. Simple relaxation techniques might be helpful.
                        </c:when>
                        <c:when test="${assessment.anxietyScore <= 14}">
                            Moderate anxiety detected. Consider mindfulness practices and stress management techniques.
                        </c:when>
                        <c:when test="${assessment.anxietyScore <= 19}">
                            You're experiencing severe anxiety. Professional guidance can help develop coping strategies.
                        </c:when>
                        <c:otherwise>
                            Extremely severe anxiety detected. Please seek professional support for comprehensive care.
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="result-card" id="stressCard">
                <h3><i class="fas fa-weight-hanging"></i> Stress</h3>
                <div class="result-score">${assessment.stressScore}</div>
                <div class="result-severity severity-${fn:toLowerCase(fn:replace(assessment.stressSeverity, ' ', '-'))}">
                    ${assessment.stressSeverity}
                </div>
                <div class="result-description">
                    <c:choose>
                        <c:when test="${assessment.stressScore <= 14}">
                            Your stress level is normal. You're handling stress effectively.
                        </c:when>
                        <c:when test="${assessment.stressScore <= 18}">
                            Mild stress detected. Consider incorporating regular breaks and relaxation into your day.
                        </c:when>
                        <c:when test="${assessment.stressScore <= 25}">
                            You're experiencing moderate stress. Time management and self-care strategies could be beneficial.
                        </c:when>
                        <c:when test="${assessment.stressScore <= 33}">
                            Severe stress levels detected. Professional support can help develop effective stress management techniques.
                        </c:when>
                        <c:otherwise>
                            Extremely severe stress detected. It's important to prioritize self-care and seek support.
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        
        <!-- Overall Severity Summary -->
        <div style="text-align: center; margin: 40px 0;">
            <div style="display: inline-block; background: white; padding: 20px 40px; border-radius: 15px; border: 2px solid #F0D5B8;">
                <h3 style="color: #713C0B; margin-bottom: 10px;">Overall Assessment</h3>
                <div class="result-severity severity-${fn:toLowerCase(fn:replace(assessment.overallSeverity, ' ', '-'))}" 
                     style="font-size: 24px; padding: 10px 30px;">
                    ${assessment.overallSeverity}
                </div>
                <p style="color: #A06A2F; margin-top: 15px; max-width: 600px;">
                    Based on your scores, your overall mental wellbeing is categorized as 
                    <strong>${fn:toLowerCase(assessment.overallSeverity)}</strong>. 
                    This considers your depression, anxiety, and stress scores together.
                </p>
            </div>
        </div>
        
        <!-- Recommendations Section -->
        <div class="recommendations-section">
            <h2><i class="fas fa-lightbulb"></i> Personalized Recommendations</h2>
            <div class="recommendations-grid">
                <c:forEach var="recommendation" items="${recommendations}" varStatus="status">
                    <div class="recommendation-card">
                        <div class="recommendation-icon">
                            <c:choose>
                                <c:when test="${status.index == 0}">
                                    <i class="fas fa-hand-holding-heart"></i>
                                </c:when>
                                <c:when test="${status.index == 1}">
                                    <i class="fas fa-brain"></i>
                                </c:when>
                                <c:when test="${status.index == 2}">
                                    <i class="fas fa-heartbeat"></i>
                                </c:when>
                                <c:when test="${status.index == 3}">
                                    <i class="fas fa-users"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-book-open"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h3>Recommendation ${status.index + 1}</h3>
                        <p>${recommendation}</p>
                    </div>
                </c:forEach>
            </div>
        </div>
        
        <!-- Assessment History -->
        <div class="history-section">
            <h2><i class="fas fa-history"></i> Your Assessment History</h2>
            <c:choose>
                <c:when test="${not empty previousAssessments && previousAssessments.size() > 0}">
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Depression</th>
                                <th>Anxiety</th>
                                <th>Stress</th>
                                <th>Overall</th>
                                <th>Trend</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="prev" items="${previousAssessments}">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${prev.assessmentDate}" pattern="dd MMM yyyy" />
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <span>${prev.depressionScore}</span>
                                            <span class="result-severity severity-${fn:toLowerCase(fn:replace(prev.depressionSeverity, ' ', '-'))}" 
                                                  style="font-size: 12px; padding: 2px 8px;">
                                                ${prev.depressionSeverity}
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <span>${prev.anxietyScore}</span>
                                            <span class="result-severity severity-${fn:toLowerCase(fn:replace(prev.anxietySeverity, ' ', '-'))}" 
                                                  style="font-size: 12px; padding: 2px 8px;">
                                                ${prev.anxietySeverity}
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <span>${prev.stressScore}</span>
                                            <span class="result-severity severity-${fn:toLowerCase(fn:replace(prev.stressSeverity, ' ', '-'))}" 
                                                  style="font-size: 12px; padding: 2px 8px;">
                                                ${prev.stressSeverity}
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="result-severity severity-${fn:toLowerCase(fn:replace(prev.overallSeverity, ' ', '-'))}" 
                                              style="font-size: 12px; padding: 2px 8px;">
                                            ${prev.overallSeverity}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${not empty assessment}">
                                            <c:set var="depressionDiff" value="${assessment.depressionScore - prev.depressionScore}" />
                                            <c:set var="anxietyDiff" value="${assessment.anxietyScore - prev.anxietyScore}" />
                                            <c:set var="stressDiff" value="${assessment.stressScore - prev.stressScore}" />
                                            
                                            <c:choose>
                                                <c:when test="${depressionDiff > 0 or anxietyDiff > 0 or stressDiff > 0}">
                                                    <span style="color: #E74C3C;">
                                                        <i class="fas fa-arrow-up"></i> Increased
                                                    </span>
                                                </c:when>
                                                <c:when test="${depressionDiff < 0 or anxietyDiff < 0 or stressDiff < 0}">
                                                    <span style="color: #27AE60;">
                                                        <i class="fas fa-arrow-down"></i> Improved
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #7F8C8D;">
                                                        <i class="fas fa-minus"></i> Stable
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <p style="text-align: center; margin-top: 20px; color: #A06A2F; font-size: 14px;">
                        <i class="fas fa-info-circle"></i> This table shows your previous assessments for comparison.
                    </p>
                </c:when>
                <c:otherwise>
                    <div class="no-history">
                        <i class="fas fa-clipboard-list"></i>
                        <h3 style="color: #713C0B; margin: 15px 0;">No Previous Assessments</h3>
                        <p>This is your first assessment. Take another assessment in a few weeks to track your progress.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                <i class="fas fa-tachometer-alt"></i> Back to Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/student-learning-modules" class="btn btn-success">
                <i class="fas fa-graduation-cap"></i> Explore Learning Modules
            </a>
            <a href="${pageContext.request.contextPath}/self-assessment" class="btn btn-secondary">
                <i class="fas fa-redo"></i> Take Assessment Again
            </a>
            <button id="printResultsBtn" class="btn btn-secondary">
                <i class="fas fa-print"></i> Print Results
            </button>
        </div>
    </div>

    <!-- Hidden inputs for JavaScript access -->
    <input type="hidden" id="assessmentId" value="${assessment.assessmentId}">
    <input type="hidden" id="depressionScore" value="${assessment.depressionScore}">
    <input type="hidden" id="anxietyScore" value="${assessment.anxietyScore}">
    <input type="hidden" id="stressScore" value="${assessment.stressScore}">
    <input type="hidden" id="overallSeverity" value="${assessment.overallSeverity}">
    <input type="hidden" id="userId" value="${sessionScope.userId}">

    <script>
        // Save results to local storage for tracking
        document.addEventListener('DOMContentLoaded', function() {
            console.log("DEBUG: Result page loaded");
            
            // Clear any in-progress assessment data
            if (typeof(Storage) !== "undefined") {
                localStorage.removeItem('dassAssessment_' + document.getElementById('userId').value);
                console.log("DEBUG: Cleared in-progress assessment data from localStorage");
                
                // Also clear session storage
                sessionStorage.removeItem('assessmentProgress');
                sessionStorage.removeItem('currentQuestion');
                
                // Save results to recent results
                const assessmentId = document.getElementById('assessmentId').value;
                const depressionScore = document.getElementById('depressionScore').value;
                const anxietyScore = document.getElementById('anxietyScore').value;
                const stressScore = document.getElementById('stressScore').value;
                const overallSeverity = document.getElementById('overallSeverity').value;
                
                if (assessmentId && assessmentId > 0) {
                    const results = {
                        assessmentId: parseInt(assessmentId),
                        date: new Date().toISOString(),
                        depressionScore: parseInt(depressionScore),
                        anxietyScore: parseInt(anxietyScore),
                        stressScore: parseInt(stressScore),
                        overallSeverity: overallSeverity
                    };
                    
                    console.log("DEBUG: Saving results to local storage:", results);
                    
                    // Save to recent results
                    let recentResults = JSON.parse(localStorage.getItem('recentAssessmentResults') || '[]');
                    
                    // Check if this assessment is already saved
                    const existingIndex = recentResults.findIndex(r => r.assessmentId === results.assessmentId);
                    if (existingIndex >= 0) {
                        // Update existing entry
                        recentResults[existingIndex] = results;
                    } else {
                        // Add new entry
                        recentResults.unshift(results);
                    }
                    
                    // Keep only last 5 results
                    recentResults = recentResults.slice(0, 5);
                    localStorage.setItem('recentAssessmentResults', JSON.stringify(recentResults));
                    
                    console.log("DEBUG: Results saved to local storage");
                }
            }
            
            // Show success message if just completed assessment
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('success')) {
                console.log("DEBUG: Assessment completed successfully");
            }
            
            // Add visual effects to result cards
            const cards = document.querySelectorAll('.result-card');
            cards.forEach((card, index) => {
                // Add animation delay
                card.style.animationDelay = (index * 0.2) + 's';
                card.style.animation = 'fadeInUp 0.6s ease-out forwards';
                card.style.opacity = '0';
                
                // Add click effect
                card.addEventListener('click', function() {
                    this.style.transform = 'scale(0.98)';
                    setTimeout(() => {
                        this.style.transform = 'translateY(-5px)';
                    }, 150);
                });
            });
            
            // Add CSS animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
            `;
            document.head.appendChild(style);
            
            // User dropdown functionality
            const userBtn = document.getElementById('userBtn');
            const dropdown = document.getElementById('dropdown');
            
            if (userBtn && dropdown) {
                userBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    dropdown.classList.toggle('show');
                });
                
                document.addEventListener('click', function() {
                    dropdown.classList.remove('show');
                });
                
                dropdown.addEventListener('click', function(e) { 
                    e.stopPropagation(); 
                });
            }
            
            // Print functionality
            document.getElementById('printResultsBtn').addEventListener('click', function() {
                window.print();
            });
            
            // Add print styles
            const printStyle = document.createElement('style');
            printStyle.textContent = `
                @media print {
                    .top-nav, .action-buttons, .history-section {
                        display: none !important;
                    }
                    body {
                        background: white !important;
                        color: black !important;
                    }
                    .result-card {
                        break-inside: avoid;
                        box-shadow: none !important;
                        border: 1px solid #ddd !important;
                    }
                    .page-title {
                        text-align: left !important;
                    }
                }
            `;
            document.head.appendChild(printStyle);
            
            // Auto-hide messages after 5 seconds
            setTimeout(function() {
                const messages = document.querySelectorAll('.success-message, .error-message');
                messages.forEach(function(msg) {
                    msg.style.transition = 'opacity 0.5s ease';
                    msg.style.opacity = '0';
                    setTimeout(() => msg.style.display = 'none', 500);
                });
            }, 5000);
        });
        
        // Export results function
        function exportResults(format) {
            const assessmentId = document.getElementById('assessmentId').value;
            const depressionScore = document.getElementById('depressionScore').value;
            const anxietyScore = document.getElementById('anxietyScore').value;
            const stressScore = document.getElementById('stressScore').value;
            const overallSeverity = document.getElementById('overallSeverity').value;
            
            if (format === 'json') {
                const data = {
                    assessmentId: assessmentId,
                    depressionScore: depressionScore,
                    anxietyScore: anxietyScore,
                    stressScore: stressScore,
                    overallSeverity: overallSeverity,
                    date: new Date().toISOString()
                };
                
                const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `assessment-${assessmentId}.json`;
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
                
                alert('Results exported as JSON file');
            }
        }
    </script>
</body>
</html>