<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Assessment History - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #FBF6EA;
            color: #713C0B;
            font-family: 'Fredoka', sans-serif;
            padding-bottom: 40px;
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .history-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            border: 2px solid #F0D5B8;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .history-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .severity-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary mb-4">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        
        <h1 class="mb-4">My Assessment History</h1>
        
        <c:choose>
            <c:when test="${not empty assessments}">
                <div class="row">
                    <c:forEach var="assessment" items="${assessments}">
                        <div class="col-md-6 mb-4">
                            <div class="history-card" 
                                 onclick="window.location.href='${pageContext.request.contextPath}/self-assessment/result/${assessment.assessmentId}'">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h5>Assessment #${assessment.assessmentId}</h5>
                                    <small class="text-muted">
                                        <fmt:formatDate value="${assessment.assessmentDate}" pattern="dd MMM yyyy" />
                                    </small>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-4 text-center">
                                        <div class="mb-2">
                                            <strong>${assessment.depressionScore}</strong>
                                        </div>
                                        <span class="severity-badge 
                                            bg-${assessment.depressionSeverity == 'Normal' ? 'success' : 
                                                assessment.depressionSeverity == 'Mild' ? 'warning' : 
                                                assessment.depressionSeverity == 'Moderate' ? 'orange' : 
                                                assessment.depressionSeverity == 'Severe' ? 'danger' : 'dark'}">
                                            ${assessment.depressionSeverity}
                                        </span>
                                        <small class="d-block mt-1">Depression</small>
                                    </div>
                                    <div class="col-4 text-center">
                                        <div class="mb-2">
                                            <strong>${assessment.anxietyScore}</strong>
                                        </div>
                                        <span class="severity-badge 
                                            bg-${assessment.anxietySeverity == 'Normal' ? 'success' : 
                                                assessment.anxietySeverity == 'Mild' ? 'warning' : 
                                                assessment.anxietySeverity == 'Moderate' ? 'orange' : 
                                                assessment.anxietySeverity == 'Severe' ? 'danger' : 'dark'}">
                                            ${assessment.anxietySeverity}
                                        </span>
                                        <small class="d-block mt-1">Anxiety</small>
                                    </div>
                                    <div class="col-4 text-center">
                                        <div class="mb-2">
                                            <strong>${assessment.stressScore}</strong>
                                        </div>
                                        <span class="severity-badge 
                                            bg-${assessment.stressSeverity == 'Normal' ? 'success' : 
                                                assessment.stressSeverity == 'Mild' ? 'warning' : 
                                                assessment.stressSeverity == 'Moderate' ? 'orange' : 
                                                assessment.stressSeverity == 'Severe' ? 'danger' : 'dark'}">
                                            ${assessment.stressSeverity}
                                        </span>
                                        <small class="d-block mt-1">Stress</small>
                                    </div>
                                </div>
                                
                                <div class="text-center">
                                    <span class="badge bg-info">
                                        Overall: ${assessment.overallSeverity}
                                    </span>
                                </div>
                                
                                <div class="text-end mt-3">
                                    <small class="text-muted">
                                        Click to view details →
                                    </small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/self-assessment" class="btn btn-primary">
                        <i class="fas fa-plus-circle"></i> Take New Assessment
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="fas fa-clipboard-list fa-4x text-muted mb-4"></i>
                    <h3>No Assessments Yet</h3>
                    <p class="text-muted mb-4">Take your first DASS-21 assessment to track your mental well-being.</p>
                    <a href="${pageContext.request.contextPath}/self-assessment" class="btn btn-primary btn-lg">
                        <i class="fas fa-play-circle"></i> Start Your First Assessment
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>