<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment History - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

        .history-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .assessment-info-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin: 30px auto;
            border: 2px solid #F0D5B8;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            max-width: 800px;
        }

        .assessment-info-card h2 {
            color: #713C0B;
            font-size: 22px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .info-item {
            padding: 10px;
            background: #FFF9F0;
            border-radius: 8px;
            border: 1px solid #F0D5B8;
        }

        .info-label {
            font-weight: 600;
            color: #D7923B;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .info-value {
            color: #713C0B;
            font-size: 16px;
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

        .history-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .history-item {
            background: white;
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid #D7923B;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            position: relative;
        }

        .history-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .history-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .history-action {
            background: #F0D5B8;
            color: #713C0B;
            padding: 6px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .history-date {
            color: #A06A2F;
            font-size: 14px;
            background: #FFF9F0;
            padding: 4px 12px;
            border-radius: 15px;
        }

        .history-details {
            color: #713C0B;
            margin: 15px 0;
            line-height: 1.6;
            padding: 15px;
            background: #FFF9F0;
            border-radius: 8px;
            border-left: 3px solid #D7923B;
        }

        .history-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px dashed #F0D5B8;
            flex-wrap: wrap;
            gap: 10px;
        }

        .history-performer {
            color: #D7923B;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .no-history {
            text-align: center;
            padding: 40px 20px;
            color: #A06A2F;
        }

        .no-history i {
            font-size: 48px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .no-history h3 {
            color: #713C0B;
            margin: 15px 0;
            font-size: 20px;
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

        .action-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
        }

        .icon-created { background: #2ECC71; color: white; }
        .icon-updated { background: #F39C12; color: white; }
        .icon-deleted { background: #E74C3C; color: white; }
        .icon-viewed { background: #3498DB; color: white; }
        .icon-exported { background: #9B59B6; color: white; }

        @media (max-width: 768px) {
            .top-nav {
                padding: 15px 20px;
            }
            
            .history-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
            
            .history-meta {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
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
                <a href="${pageContext.request.contextPath}/self-assessment" class="menu-item">
                    <i class="fas fa-clipboard-check"></i> Take Assessment
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <div style="max-width: 1000px; margin: 20px auto; padding: 0 20px;">
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
        <h1>Assessment History</h1>
        <p>Track all activities and changes for this assessment</p>
    </div>

    <div class="history-container">
        <!-- Assessment Information -->
        <div class="assessment-info-card">
            <h2><i class="fas fa-info-circle"></i> Assessment Information</h2>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Assessment ID</div>
                    <div class="info-value">A${assessment.assessmentId}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Student</div>
                    <div class="info-value">${assessment.userFullName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Assessment Date</div>
                    <div class="info-value">
                        <fmt:formatDate value="${assessment.assessmentDate}" pattern="dd MMM yyyy 'at' hh:mm a" />
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Overall Severity</div>
                    <div class="info-value" style="font-weight: 600; color: #D7923B;">
                        ${assessment.overallSeverity}
                    </div>
                </div>
            </div>
        </div>

        <!-- History Section -->
        <div class="history-section">
            <h2><i class="fas fa-history"></i> Activity History</h2>
            <c:choose>
                <c:when test="${not empty history && history.size() > 0}">
                    <div class="history-list">
                        <c:forEach var="item" items="${history}">
                            <div class="history-item">
                                <div class="history-header">
                                    <div class="history-action">
                                        <c:choose>
                                            <c:when test="${item.action_type == 'CREATED'}">
                                                <div class="action-icon icon-created">
                                                    <i class="fas fa-plus"></i>
                                                </div>
                                                Created
                                            </c:when>
                                            <c:when test="${item.action_type == 'UPDATED'}">
                                                <div class="action-icon icon-updated">
                                                    <i class="fas fa-edit"></i>
                                                </div>
                                                Updated
                                            </c:when>
                                            <c:when test="${item.action_type == 'DELETED'}">
                                                <div class="action-icon icon-deleted">
                                                    <i class="fas fa-trash"></i>
                                                </div>
                                                Deleted
                                            </c:when>
                                            <c:when test="${item.action_type == 'VIEWED'}">
                                                <div class="action-icon icon-viewed">
                                                    <i class="fas fa-eye"></i>
                                                </div>
                                                Viewed
                                            </c:when>
                                            <c:when test="${item.action_type == 'EXPORTED'}">
                                                <div class="action-icon icon-exported">
                                                    <i class="fas fa-download"></i>
                                                </div>
                                                Exported
                                            </c:when>
                                            <c:otherwise>
                                                <div class="action-icon" style="background: #95A5A6; color: white;">
                                                    <i class="fas fa-cog"></i>
                                                </div>
                                                ${item.action_type}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="history-date">
                                        <i class="far fa-clock"></i>
                                        <fmt:formatDate value="${item.performed_at}" pattern="dd MMM yyyy, HH:mm" />
                                    </div>
                                </div>
                                
                                <div class="history-details">
                                    ${item.action_details}
                                </div>
                                
                                <div class="history-meta">
                                    <div class="history-performer">
                                        <i class="fas fa-user-circle"></i>
                                        Performed by: ${item.performed_by}
                                    </div>
                                    <div style="font-size: 12px; color: #95A5A6;">
                                        <i class="fas fa-database"></i> 
                                        Record ID: ${item.history_id}
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div style="text-align: center; margin-top: 30px; color: #A06A2F; font-size: 14px;">
                        <i class="fas fa-info-circle"></i> 
                        Showing ${history.size()} activity log entries
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-history">
                        <i class="fas fa-history"></i>
                        <h3>No History Found</h3>
                        <p>No activity history has been recorded for this assessment yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/self-assessment/manage" class="btn btn-primary">
                <i class="fas fa-arrow-left"></i> Back to Management
            </a>
            <button onclick="window.print()" class="btn btn-secondary">
                <i class="fas fa-print"></i> Print History
            </button>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
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
            
            // Add animation to history items
            const historyItems = document.querySelectorAll('.history-item');
            historyItems.forEach((item, index) => {
                item.style.animationDelay = (index * 0.1) + 's';
                item.style.animation = 'fadeInUp 0.4s ease-out forwards';
                item.style.opacity = '0';
            });
            
            // Add CSS animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(10px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
            `;
            document.head.appendChild(style);
            
            // Auto-hide messages after 5 seconds
            setTimeout(function() {
                const messages = document.querySelectorAll('.success-message, .error-message');
                messages.forEach(function(msg) {
                    msg.style.transition = 'opacity 0.5s ease';
                    msg.style.opacity = '0';
                    setTimeout(() => msg.style.display = 'none', 500);
                });
            }, 5000);
            
            // Add print styles
            const printStyle = document.createElement('style');
            printStyle.textContent = `
                @media print {
                    .top-nav, .action-buttons {
                        display: none !important;
                    }
                    body {
                        background: white !important;
                        color: black !important;
                    }
                    .history-item {
                        break-inside: avoid;
                        box-shadow: none !important;
                        border: 1px solid #ddd !important;
                    }
                    .page-title {
                        text-align: left !important;
                    }
                    .assessment-info-card {
                        border: 1px solid #ddd !important;
                    }
                }
            `;
            document.head.appendChild(printStyle);
        });
    </script>
</body>
</html>