<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment Details - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Reuse the same styles from assessmentManagement.jsp */
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
        .back-btn {
            margin-bottom: 20px;
        }
        .assessment-header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            border: 2px solid #F0D5B8;
        }
        .answers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .answer-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #E2D5C1;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/self-assessment/manage" class="btn btn-secondary back-btn">
            <i class="fas fa-arrow-left"></i> Back to Management
        </a>
        
        <div class="assessment-header">
            <h1>Assessment Details</h1>
            <p>Assessment ID: A${assessment.assessmentId}</p>
            <p>Student: ${assessment.userFullName} (${assessment.userName})</p>
            <p>Date: <fmt:formatDate value="${assessment.assessmentDate}" pattern="dd MMM yyyy, HH:mm" /></p>
        </div>
        
        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Depression</h5>
                        <h2>${assessment.depressionScore}</h2>
                        <span class="badge bg-${assessment.depressionSeverity == 'Normal' ? 'success' : 
                            assessment.depressionSeverity == 'Mild' ? 'warning' : 
                            assessment.depressionSeverity == 'Moderate' ? 'orange' : 
                            assessment.depressionSeverity == 'Severe' ? 'danger' : 'dark'}">
                            ${assessment.depressionSeverity}
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Anxiety</h5>
                        <h2>${assessment.anxietyScore}</h2>
                        <span class="badge bg-${assessment.anxietySeverity == 'Normal' ? 'success' : 
                            assessment.anxietySeverity == 'Mild' ? 'warning' : 
                            assessment.anxietySeverity == 'Moderate' ? 'orange' : 
                            assessment.anxietySeverity == 'Severe' ? 'danger' : 'dark'}">
                            ${assessment.anxietySeverity}
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Stress</h5>
                        <h2>${assessment.stressScore}</h2>
                        <span class="badge bg-${assessment.stressSeverity == 'Normal' ? 'success' : 
                            assessment.stressSeverity == 'Mild' ? 'warning' : 
                            assessment.stressSeverity == 'Moderate' ? 'orange' : 
                            assessment.stressSeverity == 'Severe' ? 'danger' : 'dark'}">
                            ${assessment.stressSeverity}
                        </span>
                    </div>
                </div>
            </div>
        </div>
        
        <c:if test="${not empty assessment.answers}">
            <h3 class="mt-5">Individual Answers</h3>
            <div class="answers-grid">
                <c:forEach var="answer" items="${assessment.answers}">
                    <div class="answer-card">
                        <h5>Question ${answer.questionNumber}</h5>
                        <p>Answer: ${answer.answerValue}</p>
                        <p>Type: ${answer.questionType}</p>
                        <small>
                            Score: ${answer.answerValue} 
                            <c:if test="${answer.questionType == 'depression'}">× 2 = ${answer.answerValue * 2}</c:if>
                            <c:if test="${answer.questionType == 'anxiety'}">× 2 = ${answer.answerValue * 2}</c:if>
                            <c:if test="${answer.questionType == 'stress'}">× 2 = ${answer.answerValue * 2}</c:if>
                        </small>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</body>
</html>