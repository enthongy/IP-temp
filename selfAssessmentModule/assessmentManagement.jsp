<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment Management - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background: #FBF6EA;
            color: #713C0B;
            font-family: 'Fredoka', sans-serif;
            padding-bottom: 40px;
            min-height: 100vh;
        }

        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 22px 40px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #F0A548;
            text-decoration: none;
            cursor: pointer;
        }

        .logo:hover {
            color: #D7923B;
            text-decoration: none;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 20px;
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

        .page-header {
            padding: 30px 40px 20px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 { 
            color: #F0A548; 
            font-size: 36px; 
            font-weight: 700; 
            margin-bottom: 10px;
        }
        
        .page-title p { 
            font-size: 16px; 
            color: #A06A2F; 
            margin-bottom: 0;
        }

        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .export-btn {
            padding: 10px 20px;
            background: #27AE60;
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .export-btn:hover {
            background: #219653;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stats-card {
            background: #FFFFFF;
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 2px solid transparent;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
            border-color: #F0D5B8;
        }

        .stats-card h3 { 
            font-size: 16px; 
            font-weight: 600; 
            margin: 0 0 15px 0; 
            color: #6B4F36;
        }
        
        .stats-card .score {
            font-size: 32px;
            font-weight: 700;
            color: #713C0B;
            margin: 0;
        }
        
        .stats-card .stats-details {
            margin-top: 15px;
            font-size: 14px;
            color: #A06A2F;
        }

        .filter-section {
            background: #FFFFFF;
            padding: 25px;
            border-radius: 20px;
            margin-bottom: 30px;
            border: 2px solid #F0D5B8;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
        }

        .filter-row {
            display: grid;
            grid-template-columns: 1fr 1fr auto auto;
            gap: 15px;
            align-items: end;
        }

        .filter-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #713C0B;
            font-size: 14px;
        }

        .filter-input, .filter-select {
            width: 100%;
            padding: 12px 15px;
            border-radius: 12px;
            border: 2px solid #E2D5C1;
            background: #FBF6EA;
            font-size: 14px;
            color: #713C0B;
            transition: all 0.3s ease;
        }

        .filter-input:focus, .filter-select:focus {
            outline: none;
            border-color: #D7923B;
            background: #FFFFFF;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }

        .filter-btn {
            padding: 12px 25px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .filter-btn:hover {
            background: #C77D2F;
            transform: translateY(-2px);
        }

        .clear-btn {
            padding: 12px 25px;
            background: #6B4F36;
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            white-space: nowrap;
        }

        .clear-btn:hover {
            background: #5A2F08;
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }

        .assessments-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 40px;
        }

        .assessments-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .assessments-count {
            font-size: 18px;
            color: #713C0B;
            font-weight: 600;
        }

        .assessments-table-container {
            background: white;
            border-radius: 18px;
            border: 2px solid #F0D5B8;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .assessments-table {
            width: 100%;
            border-collapse: collapse;
        }

        .assessments-table th {
            background: #F0A548;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
        }

        .assessments-table td {
            padding: 15px;
            border-bottom: 1px solid #E2D5C1;
            vertical-align: middle;
        }

        .assessments-table tr:hover {
            background: #FFF9F0;
        }

        .assessments-table tr:last-child td {
            border-bottom: none;
        }

        .severity-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            text-align: center;
            min-width: 100px;
        }

        .severity-normal { background: #2ECC71; color: white; }
        .severity-mild { background: #F39C12; color: white; }
        .severity-moderate { background: #E67E22; color: white; }
        .severity-severe { background: #E74C3C; color: white; }
        .severity-extremely-severe { background: #8B0000; color: white; }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 6px 12px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
        }

        .btn-view {
            background: #BDF5C6;
            color: #27AE60;
        }
        
        .btn-view:hover {
            background: #A0EFB4;
            transform: translateY(-2px);
            text-decoration: none;
            color: #27AE60;
        }

        .btn-history {
            background: #E3F2FD;
            color: #2980B9;
        }
        
        .btn-history:hover {
            background: #BBDEFB;
            transform: translateY(-2px);
            text-decoration: none;
            color: #2980B9;
        }

        .btn-delete {
            background: #FDEDED;
            color: #E74C3C;
        }
        
        .btn-delete:hover {
            background: #F5B7B1;
            transform: translateY(-2px);
            color: #E74C3C;
        }

        .no-results {
            text-align: center;
            padding: 60px 20px;
            color: #7F8C8D;
        }

        .no-results i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .no-results h3 {
            margin-bottom: 10px;
            color: #713C0B;
        }

        .alert-message {
            max-width: 1400px;
            margin: 0 auto 20px;
            padding: 0 40px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #c3e6cb;
            margin-bottom: 20px;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #f5c6cb;
            margin-bottom: 20px;
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
            max-height: 80vh;
            overflow-y: auto;
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

        .modal-header {
            margin-bottom: 20px;
        }

        .modal-header h2 {
            color: #F0A548;
            margin: 0;
        }

        .assessment-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .detail-item {
            padding: 10px;
            background: #FBF6EA;
            border-radius: 10px;
        }

        .detail-label {
            font-size: 12px;
            color: #A06A2F;
            margin-bottom: 5px;
        }

        .detail-value {
            font-size: 16px;
            font-weight: 600;
            color: #713C0B;
        }

        .charts-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin: 40px 0;
        }

        .chart-container {
            background: white;
            padding: 20px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            height: 300px;
        }

        .chart-container h3 {
            margin-bottom: 20px;
            color: #713C0B;
            font-size: 18px;
            text-align: center;
        }

        @media (max-width: 1200px) {
            .filter-row {
                grid-template-columns: 1fr 1fr;
            }
            
            .charts-section {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .top-nav {
                padding: 15px 20px;
            }
            
            .page-header, .assessments-container {
                padding: 0 20px;
            }
            
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            .header-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .stats-section {
                grid-template-columns: 1fr;
            }
            
            .assessments-table {
                display: block;
                overflow-x: auto;
            }
            
            .assessment-details {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/dashboard" class="logo">SmileSpace</a>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/self-assessment/export/csv${not empty param.search or not empty param.severity ? '?' : ''}${not empty param.search ? 'search=' : ''}${param.search}${not empty param.search and not empty param.severity ? '&' : ''}${not empty param.severity ? 'severity=' : ''}${param.severity}" 
               class="export-btn">
                <i class="fas fa-file-export"></i> Export CSV
            </a>
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
    </div>

    <!-- Alert Messages -->
    <div class="alert-message">
        <c:if test="${not empty success}">
            <div class="alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
    </div>

    <div class="page-header">
        <div class="page-title">
            <h1>Assessment Management</h1>
            <p>View and analyze student DASS-21 assessments</p>
        </div>

        <div class="header-actions">
            <div class="assessments-count">
                <i class="fas fa-clipboard-list"></i> 
                <c:choose>
                    <c:when test="${not empty assessments}">
                        Showing ${assessments.size()} assessment(s)
                    </c:when>
                    <c:otherwise>
                        Showing 0 assessments
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Stats Section -->
        <div class="stats-section">
            <div class="stats-card">
                <h3>Average Depression Score</h3>
                <p class="score">
                    <fmt:formatNumber value="${averageScores.depression}" pattern="#0.0" />
                </p>
                <div class="stats-details">Across all assessments</div>
            </div>
            
            <div class="stats-card">
                <h3>Average Anxiety Score</h3>
                <p class="score">
                    <fmt:formatNumber value="${averageScores.anxiety}" pattern="#0.0" />
                </p>
                <div class="stats-details">Across all assessments</div>
            </div>
            
            <div class="stats-card">
                <h3>Average Stress Score</h3>
                <p class="score">
                    <fmt:formatNumber value="${averageScores.stress}" pattern="#0.0" />
                </p>
                <div class="stats-details">Across all assessments</div>
            </div>
            
            <div class="stats-card">
                <h3>Total Assessments</h3>
                <p class="score">
                    <c:choose>
                        <c:when test="${not empty assessments}">
                            ${assessments.size()}
                        </c:when>
                        <c:otherwise>
                            0
                        </c:otherwise>
                    </c:choose>
                </p>
                <div class="stats-details">Completed assessments</div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="charts-section">
            <div class="chart-container">
                <h3>Severity Distribution</h3>
                <canvas id="severityChart"></canvas>
            </div>
            <div class="chart-container">
                <h3>Score Averages</h3>
                <canvas id="scoresChart"></canvas>
            </div>
        </div>

        <!-- Hidden inputs for chart data -->
        <input type="hidden" id="severityNormal" value="${severityDistribution['Normal'] != null ? severityDistribution['Normal'] : 0}">
        <input type="hidden" id="severityMild" value="${severityDistribution['Mild'] != null ? severityDistribution['Mild'] : 0}">
        <input type="hidden" id="severityModerate" value="${severityDistribution['Moderate'] != null ? severityDistribution['Moderate'] : 0}">
        <input type="hidden" id="severitySevere" value="${severityDistribution['Severe'] != null ? severityDistribution['Severe'] : 0}">
        <input type="hidden" id="severityExtremelySevere" value="${severityDistribution['Extremely Severe'] != null ? severityDistribution['Extremely Severe'] : 0}">

        <input type="hidden" id="avgDepression" value="${averageScores.depression}">
        <input type="hidden" id="avgAnxiety" value="${averageScores.anxiety}">
        <input type="hidden" id="avgStress" value="${averageScores.stress}">

        <!-- Filters Section -->
        <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/self-assessment/manage" class="filter-form" id="filterForm">
                <div class="filter-row">
                    <div class="filter-group">
                        <label><i class="fas fa-search"></i> Search by Student</label>
                        <input type="text" name="search" placeholder="Search by student name..." 
                               class="filter-input" id="searchInput" value="${param.search}">
                    </div>
                    
                    <div class="filter-group">
                        <label><i class="fas fa-chart-line"></i> Overall Severity</label>
                        <select name="severity" class="filter-select" id="severitySelect">
                            <option value="">All Severities</option>
                            <option value="Normal" ${param.severity == 'Normal' ? 'selected' : ''}>Normal</option>
                            <option value="Mild" ${param.severity == 'Mild' ? 'selected' : ''}>Mild</option>
                            <option value="Moderate" ${param.severity == 'Moderate' ? 'selected' : ''}>Moderate</option>
                            <option value="Severe" ${param.severity == 'Severe' ? 'selected' : ''}>Severe</option>
                            <option value="Extremely Severe" ${param.severity == 'Extremely Severe' ? 'selected' : ''}>Extremely Severe</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="filter-btn">
                        <i class="fas fa-filter"></i> Apply Filters
                    </button>
                    
                    <a href="${pageContext.request.contextPath}/self-assessment/manage" class="clear-btn">
                        <i class="fas fa-redo"></i> Clear Filters
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Assessments Table -->
    <div class="assessments-container">
        <div class="assessments-table-container">
            <table class="assessments-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student Name</th>
                        <th>Date</th>
                        <th>Depression</th>
                        <th>Anxiety</th>
                        <th>Stress</th>
                        <th>Overall Severity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty assessments}">
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 40px;">
                                    <div class="no-results">
                                        <i class="fas fa-clipboard-list"></i>
                                        <h3>No assessments found</h3>
                                        <p>Try adjusting your search filters</p>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="assessment" items="${assessments}">
                                <tr id="assessment-${assessment.assessmentId}">
                                    <td>A${assessment.assessmentId}</td>
                                    <td>
                                        <strong>${assessment.userFullName}</strong>
                                        <div style="font-size: 12px; color: #A06A2F;">
                                            ${assessment.userName}
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${assessment.assessmentDate}" pattern="dd/MM/yyyy" />
                                    </td>
                                    <td>
                                        <div class="score-value">${assessment.depressionScore}</div>
                                        <div class="severity-badge 
                                            <c:choose>
                                                <c:when test="${assessment.depressionSeverity == 'Normal'}">severity-normal</c:when>
                                                <c:when test="${assessment.depressionSeverity == 'Mild'}">severity-mild</c:when>
                                                <c:when test="${assessment.depressionSeverity == 'Moderate'}">severity-moderate</c:when>
                                                <c:when test="${assessment.depressionSeverity == 'Severe'}">severity-severe</c:when>
                                                <c:when test="${assessment.depressionSeverity == 'Extremely Severe'}">severity-extremely-severe</c:when>
                                            </c:choose>">
                                            ${assessment.depressionSeverity}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="score-value">${assessment.anxietyScore}</div>
                                        <div class="severity-badge 
                                            <c:choose>
                                                <c:when test="${assessment.anxietySeverity == 'Normal'}">severity-normal</c:when>
                                                <c:when test="${assessment.anxietySeverity == 'Mild'}">severity-mild</c:when>
                                                <c:when test="${assessment.anxietySeverity == 'Moderate'}">severity-moderate</c:when>
                                                <c:when test="${assessment.anxietySeverity == 'Severe'}">severity-severe</c:when>
                                                <c:when test="${assessment.anxietySeverity == 'Extremely Severe'}">severity-extremely-severe</c:when>
                                            </c:choose>">
                                            ${assessment.anxietySeverity}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="score-value">${assessment.stressScore}</div>
                                        <div class="severity-badge 
                                            <c:choose>
                                                <c:when test="${assessment.stressSeverity == 'Normal'}">severity-normal</c:when>
                                                <c:when test="${assessment.stressSeverity == 'Mild'}">severity-mild</c:when>
                                                <c:when test="${assessment.stressSeverity == 'Moderate'}">severity-moderate</c:when>
                                                <c:when test="${assessment.stressSeverity == 'Severe'}">severity-severe</c:when>
                                                <c:when test="${assessment.stressSeverity == 'Extremely Severe'}">severity-extremely-severe</c:when>
                                            </c:choose>">
                                            ${assessment.stressSeverity}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="severity-badge 
                                            <c:choose>
                                                <c:when test="${assessment.overallSeverity == 'Normal'}">severity-normal</c:when>
                                                <c:when test="${assessment.overallSeverity == 'Mild'}">severity-mild</c:when>
                                                <c:when test="${assessment.overallSeverity == 'Moderate'}">severity-moderate</c:when>
                                                <c:when test="${assessment.overallSeverity == 'Severe'}">severity-severe</c:when>
                                                <c:when test="${assessment.overallSeverity == 'Extremely Severe'}">severity-extremely-severe</c:when>
                                            </c:choose>">
                                            ${assessment.overallSeverity}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="#" class="btn-action btn-view view-btn" 
                                            data-assessment-id="${assessment.assessmentId}">
                                                <i class="fas fa-eye"></i> View
                                            </a>
                                            <a href="${pageContext.request.contextPath}/self-assessment/history/${assessment.assessmentId}" 
                                            class="btn-action btn-history">
                                                <i class="fas fa-history"></i> History
                                            </a>
                                            <form action="${pageContext.request.contextPath}/self-assessment/delete" 
                                                method="post" 
                                                class="delete-form"
                                                data-assessment-id="${assessment.assessmentId}"
                                                style="display: inline;">
                                                <input type="hidden" name="assessmentId" value="${assessment.assessmentId}">
                                                <button type="submit" class="btn-action btn-delete">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Assessment Details Modal -->
    <div class="modal" id="detailsModal">
        <div class="modal-content">
            <button class="modal-close" onclick="closeModal()">&times;</button>
            <div class="modal-header">
                <h2>Assessment Details</h2>
            </div>
            <div id="modalContent">
                <!-- Content will be loaded via AJAX -->
            </div>
        </div>
    </div>

    <script>
        // Charts
        document.addEventListener('DOMContentLoaded', function() {
            // Get chart data from hidden inputs
            const severityNormal = parseInt(document.getElementById('severityNormal').value) || 0;
            const severityMild = parseInt(document.getElementById('severityMild').value) || 0;
            const severityModerate = parseInt(document.getElementById('severityModerate').value) || 0;
            const severitySevere = parseInt(document.getElementById('severitySevere').value) || 0;
            const severityExtremelySevere = parseInt(document.getElementById('severityExtremelySevere').value) || 0;
            
            const avgDepression = parseFloat(document.getElementById('avgDepression').value) || 0;
            const avgAnxiety = parseFloat(document.getElementById('avgAnxiety').value) || 0;
            const avgStress = parseFloat(document.getElementById('avgStress').value) || 0;
            
            // Severity Distribution Chart
            const severityCtx = document.getElementById('severityChart').getContext('2d');
            const severityData = {
                labels: ['Normal', 'Mild', 'Moderate', 'Severe', 'Extremely Severe'],
                datasets: [{
                    data: [
                        severityNormal,
                        severityMild,
                        severityModerate,
                        severitySevere,
                        severityExtremelySevere
                    ],
                    backgroundColor: [
                        '#2ECC71',
                        '#F39C12',
                        '#E67E22',
                        '#E74C3C',
                        '#8B0000'
                    ],
                    borderWidth: 2,
                    borderColor: '#FBF6EA'
                }]
            };
            
            new Chart(severityCtx, {
                type: 'doughnut',
                data: severityData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                                font: {
                                    size: 12,
                                    family: 'Fredoka, sans-serif'
                                }
                            }
                        }
                    }
                }
            });
            
            // Scores Averages Chart
            const scoresCtx = document.getElementById('scoresChart').getContext('2d');
            const scoresData = {
                labels: ['Depression', 'Anxiety', 'Stress'],
                datasets: [{
                    label: 'Average Scores',
                    data: [
                        avgDepression,
                        avgAnxiety,
                        avgStress
                    ],
                    backgroundColor: [
                        'rgba(46, 204, 113, 0.7)',
                        'rgba(243, 156, 18, 0.7)',
                        'rgba(231, 76, 60, 0.7)'
                    ],
                    borderColor: [
                        '#2ECC71',
                        '#F39C12',
                        '#E74C3C'
                    ],
                    borderWidth: 2
                }]
            };
            
            new Chart(scoresCtx, {
                type: 'bar',
                data: scoresData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Average Score',
                                font: {
                                    family: 'Fredoka, sans-serif'
                                }
                            },
                            ticks: {
                                font: {
                                    family: 'Fredoka, sans-serif'
                                }
                            }
                        },
                        x: {
                            ticks: {
                                font: {
                                    family: 'Fredoka, sans-serif'
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        });
        
        // User dropdown
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
        
        // Modal functions
        function showDetails(assessmentId) {
            document.getElementById('detailsModal').style.display = 'flex';
            
            // Update modal with loading state
            document.getElementById('modalContent').innerHTML = 
                '<div class="assessment-details">' +
                    '<div class="detail-item">' +
                        '<div class="detail-label">Assessment ID</div>' +
                        '<div class="detail-value">A' + assessmentId + '</div>' +
                    '</div>' +
                    '<div class="detail-item">' +
                        '<div class="detail-label">Status</div>' +
                        '<div class="detail-value">Completed</div>' +
                    '</div>' +
                    '<div class="detail-item">' +
                        '<div class="detail-label">Depression Score</div>' +
                        '<div class="detail-value">Loading...</div>' +
                    '</div>' +
                    '<div class="detail-item">' +
                        '<div class="detail-label">Anxiety Score</div>' +
                        '<div class="detail-value">Loading...</div>' +
                    '</div>' +
                    '<div class="detail-item">' +
                        '<div class="detail-label">Stress Score</div>' +
                        '<div class="detail-value">Loading...</div>' +
                    '</div>' +
                    '<div class="detail-item">' +
                        '<div class="detail-label">Overall Severity</div>' +
                        '<div class="detail-value">Loading...</div>' +
                    '</div>' +
                '</div>' +
                '<div style="text-align: center; margin-top: 20px;">' +
                    '<a href="${pageContext.request.contextPath}/self-assessment/details/' + assessmentId + '" ' +
                       'class="btn-action btn-view" style="padding: 10px 20px;">' +
                        '<i class="fas fa-external-link-alt"></i> View Full Details' +
                    '</a>' +
                '</div>';
            
            // Fetch assessment details via AJAX
            fetch('${pageContext.request.contextPath}/self-assessment/details/' + assessmentId + '/ajax')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Format date safely
                        let formattedDate = 'N/A';
                        if (data.assessmentDate) {
                            try {
                                const date = new Date(data.assessmentDate);
                                formattedDate = date.toLocaleDateString();
                            } catch (e) {
                                console.error('Error formatting date:', e);
                            }
                        }
                        
                        // Update modal with actual data
                        document.getElementById('modalContent').innerHTML = 
                            '<div class="assessment-details">' +
                                '<div class="detail-item">' +
                                    '<div class="detail-label">Assessment ID</div>' +
                                    '<div class="detail-value">A' + data.assessmentId + '</div>' +
                                '</div>' +
                                '<div class="detail-item">' +
                                    '<div class="detail-label">Student Name</div>' +
                                    '<div class="detail-value">' + (data.userFullName || 'Unknown') + '</div>' +
                                '</div>' +
                                '<div class="detail-item">' +
                                    '<div class="detail-label">Username</div>' +
                                    '<div class="detail-value">' + (data.userName || 'N/A') + '</div>' +
                                '</div>' +
                                '<div class="detail-item">' +
                                    '<div class="detail-label">Date</div>' +
                                    '<div class="detail-value">' + formattedDate + '</div>' +
                                '</div>' +
                                '<div class="detail-item">' +
                                    '<div class="detail-label">Depression Score</div>' +
                                    '<div class="detail-value">' + data.depressionScore + ' (' + data.depressionSeverity + ')</div>' +
                                '</div>' +
                                '<div class="detail-item">' +
                                    '<div class="detail-label">Anxiety Score</div>' +
                                    '<div class="detail-value">' + data.anxietyScore + ' (' + data.anxietySeverity + ')</div>' +
                                '</div>' +
                                '<div class="detail-item">' +
                                    '<div class="detail-label">Stress Score</div>' +
                                    '<div class="detail-value">' + data.stressScore + ' (' + data.stressSeverity + ')</div>' +
                                '</div>' +
                                '<div class="detail-item">' +
                                    '<div class="detail-label">Overall Severity</div>' +
                                    '<div class="detail-value">' + data.overallSeverity + '</div>' +
                                '</div>' +
                            '</div>' +
                            '<div style="text-align: center; margin-top: 20px;">' +
                                '<a href="${pageContext.request.contextPath}/self-assessment/details/' + data.assessmentId + '" ' +
                                   'class="btn-action btn-view" style="padding: 10px 20px;">' +
                                    '<i class="fas fa-external-link-alt"></i> View Full Details' +
                                '</a>' +
                            '</div>';
                    } else {
                        document.getElementById('modalContent').innerHTML = 
                            '<div style="text-align: center; padding: 20px;">' +
                                '<i class="fas fa-exclamation-circle fa-2x" style="color: #E74C3C;"></i>' +
                                '<p>Error loading assessment details: ' + (data.error || 'Unknown error') + '</p>' +
                            '</div>';
                    }
                })
                .catch(error => {
                    console.error('Error fetching assessment details:', error);
                    document.getElementById('modalContent').innerHTML = 
                        '<div style="text-align: center; padding: 20px;">' +
                            '<i class="fas fa-exclamation-circle fa-2x" style="color: #E74C3C;"></i>' +
                            '<p>Error loading assessment details. Please try again.</p>' +
                        '</div>';
                });
        }
        
        function closeModal() {
            document.getElementById('detailsModal').style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.addEventListener('click', function(event) {
            const modal = document.getElementById('detailsModal');
            if (event.target === modal) {
                closeModal();
            }
        });
        
        // Delete confirmation
        function confirmDelete(assessmentId) {
            return confirm('Are you sure you want to delete assessment A' + assessmentId + '? This action cannot be undone.');
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-success, .alert-error');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s ease-out';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 500);
            });
        }, 5000);

        // Event delegation for action buttons
        document.addEventListener('click', function(e) {
            // Handle view button click
            if (e.target.closest('.view-btn')) {
                e.preventDefault();
                const assessmentId = e.target.closest('.view-btn').getAttribute('data-assessment-id');
                showDetails(assessmentId);
            }
            
            // Handle delete form submission
            if (e.target.closest('.delete-form')) {
                const form = e.target.closest('.delete-form');
                const assessmentId = form.getAttribute('data-assessment-id');
                
                if (!confirm('Are you sure you want to delete assessment A' + assessmentId + '? This action cannot be undone.')) {
                    e.preventDefault();
                    return false;
                }
            }
        });
    </script>
</body>
</html>