<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String[] questions = (String[]) request.getAttribute("questions");
    Integer totalQuestions = (Integer) request.getAttribute("totalQuestions");
    
    if (questions == null || totalQuestions == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DASS-21 Assessment</title>
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

        .progress-bar-container {
            max-width: 800px;
            margin: 10px auto 30px;
            padding: 0 20px;
        }

        .progress-bar {
            width: 100%;
            background-color: #E2D5C1;
            height: 10px;
            border-radius: 5px;
            overflow: hidden;
        }

        .progress-bar-filled {
            height: 100%;
            width: 0%;
            background-color: #55C57A;
            border-radius: 5px;
            transition: width 0.3s ease;
        }

        .assessment-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .question-card {
            background-color: #FFFFFF;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            border: 2px solid #F0D5B8;
            display: none;
        }

        .question-card.active {
            display: block;
        }

        .question-card h3 {
            font-size: 20px;
            color: #713C0B;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .question-number {
            display: inline-block;
            background: #F0A548;
            color: white;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            text-align: center;
            line-height: 36px;
            margin-right: 10px;
            font-weight: 600;
        }

        .answer-options {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .answer-option {
            background-color: #FFF9F0;
            padding: 15px;
            border-radius: 10px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.2s ease;
        }

        .answer-option:hover {
            background-color: #FFEBC8;
            border-color: #F0D5B8;
        }

        .answer-option.selected {
            background-color: #E8F5E8;
            border-color: #55C57A;
        }

        .answer-option input[type="radio"] {
            display: none;
        }

        .answer-label {
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            font-size: 16px;
        }

        .answer-value {
            background: #D7923B;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 14px;
        }

        .answer-text {
            flex: 1;
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
            gap: 20px;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 10px;
            border: none;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: #F0A548;
            color: white;
        }

        .btn-primary:hover:not(:disabled) {
            background-color: #D7923B;
            transform: translateY(-2px);
        }

        .btn-primary:disabled {
            background-color: #E2D5C1;
            cursor: not-allowed;
        }

        .btn-secondary {
            background-color: #6B4F36;
            color: white;
        }

        .btn-secondary:hover:not(:disabled) {
            background-color: #5A2F08;
            transform: translateY(-2px);
        }

        .btn-secondary:disabled {
            background-color: #A06A2F;
            opacity: 0.5;
            cursor: not-allowed;
        }

        .instruction-box {
            background: #FFF3C8;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            border: 2px solid #F0D5B8;
            max-width: 800px;
            margin: 0 auto 30px;
        }

        .instruction-box h4 {
            color: #713C0B;
            margin-bottom: 10px;
            font-size: 18px;
        }

        .instruction-box p {
            color: #A06A2F;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .loading-spinner {
            background: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
        }

        .spinner {
            border: 5px solid #f3f3f3;
            border-top: 5px solid #F0A548;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto 15px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .error-message {
            background: #FDEDED;
            border: 2px solid #F5B7B1;
            color: #721c24;
            padding: 15px;
            border-radius: 10px;
            margin: 20px auto;
            max-width: 800px;
            display: none;
        }

        .error-message.show {
            display: block;
        }

        .success-message {
            background: #D4EDDA;
            border: 2px solid #C3E6CB;
            color: #155724;
            padding: 15px;
            border-radius: 10px;
            margin: 20px auto;
            max-width: 800px;
            display: none;
        }

        .success-message.show {
            display: block;
        }

        .progress-indicator {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            font-size: 14px;
            display: none;
            z-index: 1000;
        }

        .progress-indicator.show {
            display: block;
        }

        .auto-save-status {
            position: fixed;
            bottom: 20px;
            left: 20px;
            background: #27AE60;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 12px;
            display: none;
            animation: fadeInOut 2s ease;
        }

        @keyframes fadeInOut {
            0% { opacity: 0; }
            20% { opacity: 1; }
            80% { opacity: 1; }
            100% { opacity: 0; }
        }

        @media (max-width: 768px) {
            .top-nav {
                padding: 15px 20px;
            }
            
            .question-card {
                padding: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <div class="spinner"></div>
            <h3>Submitting Assessment...</h3>
            <p>Please wait while we redirect you to the results</p>
        </div>
    </div>

    <!-- Error Message -->
    <div class="error-message" id="errorMessage">
        <i class="fas fa-exclamation-circle"></i>
        <span id="errorText"></span>
    </div>

    <!-- Success Message -->
    <div class="success-message" id="successMessage">
        <i class="fas fa-check-circle"></i>
        <span id="successText"></span>
    </div>

    <!-- Auto-save Status -->
    <div class="auto-save-status" id="autoSaveStatus">
        <i class="fas fa-save"></i> Progress saved
    </div>

    <!-- Progress Indicator -->
    <div class="progress-indicator" id="progressIndicator">
        <div><strong>Progress:</strong> <span id="indicatorAnswered">0</span>/21 answered</div>
        <div style="font-size: 12px; color: #A06A2F; margin-top: 5px;">
            Click outside to close
        </div>
    </div>

    <!-- Top Navigation -->
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

    <!-- Page Title -->
    <div class="page-title">
        <h1>DASS-21 Assessment</h1>
        <p>Please read each statement and select the option that applies to you over the past week</p>
    </div>

    <!-- Instruction Box -->
    <div class="instruction-box" style="max-width: 800px; margin: 0 auto 30px; padding: 0 20px;">
        <h4><i class="fas fa-info-circle"></i> Instructions</h4>
        <p>• Read each statement and select how much it applied to you over the <strong>past week</strong></p>
        <p>• There are no right or wrong answers</p>
        <p>• Answer all questions honestly for accurate results</p>
        <p>• Your responses are confidential and will be used to provide personalized recommendations</p>
        <p>• Answers are saved automatically as you progress</p>
        <p><strong>DEMO MODE:</strong> Clicking submit will redirect you to the results page</p>
    </div>

    <!-- Progress Bar -->
    <div class="progress-bar-container">
        <div class="progress-bar">
            <div class="progress-bar-filled" id="progressBar"></div>
        </div>
        <div style="display: flex; justify-content: space-between; margin-top: 5px; font-size: 14px; color: #A06A2F;">
            <span>Question <span id="currentQuestion">1</span> of ${totalQuestions}</span>
            <span><span id="progressPercent">5%</span> Complete</span>
        </div>
    </div>

    <!-- Assessment Form -->
    <form id="assessmentForm">
        <div class="assessment-container">
            <c:choose>
                <c:when test="${not empty questions}">
                    <c:forEach var="question" items="${questions}" varStatus="status">
                        <div class="question-card" id="question${status.index + 1}">
                            <h3>
                                <span class="question-number">${status.index + 1}</span>
                                ${question}
                            </h3>
                            <div class="answer-options">
                                <div class="answer-option" data-index="${status.index}" data-value="0">
                                    <label class="answer-label">
                                        <input type="radio" name="answer${status.index}" value="0" required>
                                        <span class="answer-value">0</span>
                                        <span class="answer-text">Did not apply to me at all</span>
                                    </label>
                                </div>
                                <div class="answer-option" data-index="${status.index}" data-value="1">
                                    <label class="answer-label">
                                        <input type="radio" name="answer${status.index}" value="1">
                                        <span class="answer-value">1</span>
                                        <span class="answer-text">Applied to me to some degree</span>
                                    </label>
                                </div>
                                <div class="answer-option" data-index="${status.index}" data-value="2">
                                    <label class="answer-label">
                                        <input type="radio" name="answer${status.index}" value="2">
                                        <span class="answer-value">2</span>
                                        <span class="answer-text">Applied to me a considerable degree</span>
                                    </label>
                                </div>
                                <div class="answer-option" data-index="${status.index}" data-value="3">
                                    <label class="answer-label">
                                        <input type="radio" name="answer${status.index}" value="3">
                                        <span class="answer-value">3</span>
                                        <span class="answer-text">Applied to me very much</span>
                                    </label>
                                </div>
                            </div>
                            <input type="hidden" id="hiddenAnswer${status.index}" name="hiddenAnswer${status.index}" value="">
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="question-card active">
                        <h3>
                            <span class="question-number">1</span>
                            Unable to load questions. Please try again.
                        </h3>
                        <div class="answer-options">
                            <p style="color: #E74C3C; text-align: center;">
                                <i class="fas fa-exclamation-triangle"></i> 
                                Questions could not be loaded. Please refresh the page or contact support.
                            </p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <button type="button" class="btn btn-secondary" id="prevButton" onclick="prevQuestion()" disabled>
                <i class="fas fa-arrow-left"></i> Previous
            </button>
            <button type="button" class="btn btn-primary" id="nextButton" onclick="nextQuestion()">
                Next Question <i class="fas fa-arrow-right"></i>
            </button>
            <button type="button" class="btn btn-primary" id="submitButton" style="display: none;">
                <i class="fas fa-check-circle"></i> Submit Assessment
            </button>
        </div>
    </form>

    <script>
    // Global variables
    const totalQuestions = <c:out value="${totalQuestions}" />;
    let currentQuestion = 1;
    let answers = new Array(totalQuestions).fill(null);
    
    console.log("DEBUG: Assessment page loaded (Demo Mode)");
    console.log("DEBUG: Total questions: " + totalQuestions);
    
    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        showQuestion(currentQuestion);
        updateProgress();
        loadSavedProgress();
        
        // Add event delegation for answer selection
        addAnswerSelectionListeners();
        
        // Add click handler for submit button
        document.getElementById('submitButton').addEventListener('click', handleSubmit);
        
        // Show welcome message if first time
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('resume')) {
            showSuccess('Your progress has been restored. Continue where you left off.');
        }
    });
    
    function addAnswerSelectionListeners() {
        // Listen for clicks on answer options
        document.addEventListener('click', function(e) {
            const answerOption = e.target.closest('.answer-option');
            if (answerOption) {
                const questionIndex = parseInt(answerOption.getAttribute('data-index'));
                const value = parseInt(answerOption.getAttribute('data-value'));
                selectAnswer(questionIndex, value);
            }
        });
        
        // Also listen for radio button changes
        document.addEventListener('change', function(e) {
            if (e.target.type === 'radio' && e.target.name.startsWith('answer')) {
                const name = e.target.name;
                const questionIndex = parseInt(name.replace('answer', ''));
                const value = parseInt(e.target.value);
                selectAnswer(questionIndex, value);
            }
        });
    }
    
    function showQuestion(questionNum) {
        // Hide all questions
        document.querySelectorAll('.question-card').forEach(card => {
            card.classList.remove('active');
        });
        
        // Show current question
        const currentCard = document.getElementById('question' + questionNum);
        if (currentCard) {
            currentCard.classList.add('active');
            
            // Scroll to question if needed
            currentCard.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        
        // Update UI
        document.getElementById('currentQuestion').textContent = questionNum;
        updateButtons();
        updateProgress();
        
        // Auto-save progress
        autoSaveProgress();
    }
    
    function selectAnswer(questionIndex, value) {
        console.log("DEBUG: Selected answer for question " + (parseInt(questionIndex) + 1) + ": " + value);
        
        // Store answer in array
        answers[questionIndex] = value;
        
        // Update hidden input
        const hiddenInput = document.getElementById('hiddenAnswer' + questionIndex);
        if (hiddenInput) {
            hiddenInput.value = value;
        }
        
        // Update radio button state
        const radio = document.querySelector(`input[name="answer${questionIndex}"][value="${value}"]`);
        if (radio) {
            radio.checked = true;
        }
        
        // Update UI for visual selection
        const questionCard = document.getElementById('question' + (parseInt(questionIndex) + 1));
        
        if (questionCard) {
            // Remove selected class from all options in this question
            questionCard.querySelectorAll('.answer-option').forEach(option => {
                option.classList.remove('selected');
            });
            
            // Add selected class to clicked option
            const clickedOption = questionCard.querySelector(`.answer-option[data-value="${value}"]`);
            if (clickedOption) {
                clickedOption.classList.add('selected');
            }
        }
        
        // Update progress
        updateProgress();
        
        // Auto-save after selecting answer
        autoSaveProgress();
        
        // Show auto-save status
        showAutoSaveStatus();
    }
    
    function prevQuestion() {
        if (currentQuestion > 1) {
            currentQuestion--;
            showQuestion(currentQuestion);
        }
    }
    
    function nextQuestion() {
        if (currentQuestion < totalQuestions) {
            // Validate current question has answer
            if (answers[currentQuestion - 1] === null) {
                showError('Please select an answer before proceeding');
                highlightCurrentQuestion();
                return;
            }
            
            currentQuestion++;
            showQuestion(currentQuestion);
        } else {
            // Last question - show submit button
            if (answers[currentQuestion - 1] === null) {
                showError('Please select an answer before submitting');
                highlightCurrentQuestion();
                return;
            }
            
            // Show submit button
            document.getElementById('nextButton').style.display = 'none';
            document.getElementById('submitButton').style.display = 'flex';
            
            // Show confirmation message
            showSuccess('All questions answered! Ready to submit.');
        }
    }
    
    function updateButtons() {
        const prevButton = document.getElementById('prevButton');
        const nextButton = document.getElementById('nextButton');
        const submitButton = document.getElementById('submitButton');
        
        prevButton.disabled = currentQuestion === 1;
        
        if (currentQuestion === totalQuestions) {
            nextButton.innerHTML = 'Review Answers <i class="fas fa-list-check"></i>';
            
            // Check if all questions answered to show submit button
            const allAnswered = answers.every(answer => answer !== null);
            if (allAnswered) {
                nextButton.style.display = 'none';
                submitButton.style.display = 'flex';
            }
        } else {
            nextButton.innerHTML = 'Next Question <i class="fas fa-arrow-right"></i>';
            submitButton.style.display = 'none';
            nextButton.style.display = 'flex';
        }
    }
    
    function updateProgress() {
        const answeredCount = answers.filter(answer => answer !== null).length;
        const progress = (answeredCount / totalQuestions) * 100;
        
        document.getElementById('progressBar').style.width = progress + '%';
        document.getElementById('progressPercent').textContent = Math.round(progress) + '%';
        
        // Update progress indicator
        document.getElementById('indicatorAnswered').textContent = answeredCount;
        
        // Show/hide progress indicator
        if (answeredCount > 0) {
            document.getElementById('progressIndicator').classList.add('show');
        }
    }
    
    function handleSubmit() {
        console.log("DEBUG: Submit button clicked (Demo Mode)");
        
        // Validate all questions are answered
        const unanswered = [];
        for (let i = 0; i < totalQuestions; i++) {
            if (answers[i] === null || answers[i] === undefined) {
                unanswered.push(i + 1);
            }
        }
        
        if (unanswered.length > 0) {
            showError(`Please answer all ${unanswered.length} remaining question(s) before submitting. (Questions: ${unanswered.join(', ')})`);
            
            // Go to first unanswered question
            currentQuestion = unanswered[0];
            showQuestion(currentQuestion);
            return false;
        }
        
        console.log("DEBUG: All questions answered. Redirecting to result page...");
        
        // Show loading
        showLoading();
        
        // Redirect directly to result page after 1 second
        setTimeout(() => {
            console.log("DEBUG: Redirecting to result page...");
            window.location.href = "${pageContext.request.contextPath}/self-assessment/result";
        }, 1000);
        
        return true;
    }
    
    function autoSaveProgress() {
        // Prepare data for auto-save
        const answeredCount = answers.filter(answer => answer !== null).length;
        if (answeredCount === 0) {
            return;
        }
        
        const progressData = {
            answers: answers,
            currentQuestion: currentQuestion,
            answeredCount: answeredCount,
            timestamp: new Date().toISOString()
        };
        
        // Save to localStorage
        if (typeof(Storage) !== "undefined") {
            localStorage.setItem('dassAssessmentProgress', JSON.stringify(progressData));
        }
        
        // Also save to session storage
        sessionStorage.setItem('assessmentProgress', JSON.stringify(progressData));
    }
    
    function loadSavedProgress() {
        if (typeof(Storage) !== "undefined") {
            const saved = localStorage.getItem('dassAssessmentProgress');
            if (saved) {
                try {
                    const data = JSON.parse(saved);
                    
                    // Check if saved data is recent (within 24 hours)
                    if (data.timestamp) {
                        const savedTime = new Date(data.timestamp).getTime();
                        const now = new Date().getTime();
                        const hoursDiff = (now - savedTime) / (1000 * 60 * 60);
                        
                        if (hoursDiff < 24) {
                            answers = data.answers || new Array(totalQuestions).fill(null);
                            currentQuestion = data.currentQuestion || 1;
                            
                            // Restore selected answers
                            answers.forEach((answer, index) => {
                                if (answer !== null) {
                                    // Update radio button
                                    const radio = document.querySelector(`input[name="answer${index}"][value="${answer}"]`);
                                    if (radio) {
                                        radio.checked = true;
                                    }
                                    
                                    // Update hidden input
                                    const hiddenInput = document.getElementById('hiddenAnswer' + index);
                                    if (hiddenInput) {
                                        hiddenInput.value = answer;
                                    }
                                    
                                    // Update UI selection
                                    const questionCard = document.getElementById('question' + (index + 1));
                                    if (questionCard) {
                                        const option = questionCard.querySelector(`.answer-option[data-value="${answer}"]`);
                                        if (option) {
                                            option.classList.add('selected');
                                        }
                                    }
                                }
                            });
                            
                            showQuestion(currentQuestion);
                            updateProgress();
                            
                            console.log("DEBUG: Progress restored from localStorage");
                            showSuccess('Your previous progress has been restored.');
                        } else {
                            // Clear old progress
                            localStorage.removeItem('dassAssessmentProgress');
                            console.log("DEBUG: Cleared old progress (>24 hours)");
                        }
                    }
                } catch (e) {
                    console.error("ERROR: Failed to parse saved progress:", e);
                    localStorage.removeItem('dassAssessmentProgress');
                }
            }
        }
    }
    
    function showAutoSaveStatus() {
        const statusElement = document.getElementById('autoSaveStatus');
        statusElement.style.display = 'block';
        
        // Hide after 2 seconds
        setTimeout(() => {
            statusElement.style.display = 'none';
        }, 2000);
    }
    
    function showError(message) {
        const errorElement = document.getElementById('errorMessage');
        const errorText = document.getElementById('errorText');
        
        errorText.textContent = message;
        errorElement.classList.add('show');
        
        // Hide error after 5 seconds
        setTimeout(() => {
            errorElement.classList.remove('show');
        }, 5000);
        
        // Scroll to error message
        errorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    
    function showSuccess(message) {
        const successElement = document.getElementById('successMessage');
        const successText = document.getElementById('successText');
        
        successText.textContent = message;
        successElement.classList.add('show');
        
        // Hide success after 3 seconds
        setTimeout(() => {
            successElement.classList.remove('show');
        }, 3000);
    }
    
    function showLoading() {
        document.getElementById('loadingOverlay').style.display = 'flex';
    }
    
    function hideLoading() {
        document.getElementById('loadingOverlay').style.display = 'none';
    }
    
    function highlightCurrentQuestion() {
        const currentCard = document.getElementById('question' + currentQuestion);
        if (currentCard) {
            // Add highlight animation
            currentCard.style.borderColor = '#E74C3C';
            currentCard.style.boxShadow = '0 0 0 3px rgba(231, 76, 60, 0.2)';
            
            // Remove highlight after 2 seconds
            setTimeout(() => {
                currentCard.style.borderColor = '#F0D5B8';
                currentCard.style.boxShadow = '0 4px 15px rgba(0, 0, 0, 0.1)';
            }, 2000);
        }
    }
    
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
    
    // Close progress indicator when clicking outside
    document.addEventListener('click', function(e) {
        const indicator = document.getElementById('progressIndicator');
        if (indicator && !indicator.contains(e.target)) {
            indicator.classList.remove('show');
        }
    });
    
    // Save progress when leaving page
    window.addEventListener('beforeunload', function(e) {
        const answeredCount = answers.filter(answer => answer !== null).length;
        if (answeredCount > 0 && answeredCount < totalQuestions) {
            // Show confirmation message
            e.preventDefault();
            e.returnValue = 'You have unsaved answers. Are you sure you want to leave?';
            return e.returnValue;
        }
        
        // Auto-save before leaving
        autoSaveProgress();
    });
    
    // Add keyboard navigation
    document.addEventListener('keydown', function(e) {
        // Don't interfere with form inputs
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
            return;
        }
        
        switch(e.key) {
            case 'ArrowLeft':
                if (currentQuestion > 1) {
                    prevQuestion();
                    e.preventDefault();
                }
                break;
            case 'ArrowRight':
                if (currentQuestion <= totalQuestions) {
                    nextQuestion();
                    e.preventDefault();
                }
                break;
            case '0':
            case '1':
            case '2':
            case '3':
                const value = parseInt(e.key);
                selectAnswer(currentQuestion - 1, value);
                break;
        }
    });
    
    // Check for error messages from server
    window.addEventListener('load', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');
        if (error) {
            showError(decodeURIComponent(error));
        }
        
        const success = urlParams.get('success');
        if (success) {
            showSuccess(decodeURIComponent(success));
        }
    });
    
    // Export function for debugging
    window.getAssessmentData = function() {
        return {
            answers: answers,
            currentQuestion: currentQuestion,
            answeredCount: answers.filter(a => a !== null).length,
            totalQuestions: totalQuestions
        };
    };
    
    // Clear progress function
    window.clearProgress = function() {
        if (confirm('Are you sure you want to clear all your answers? This cannot be undone.')) {
            answers = new Array(totalQuestions).fill(null);
            currentQuestion = 1;
            
            // Clear all selections
            document.querySelectorAll('input[type="radio"]').forEach(radio => {
                radio.checked = false;
            });
            
            document.querySelectorAll('.answer-option.selected').forEach(option => {
                option.classList.remove('selected');
            });
            
            document.querySelectorAll('input[type="hidden"][id^="hiddenAnswer"]').forEach(input => {
                input.value = '';
            });
            
            // Clear storage
            localStorage.removeItem('dassAssessmentProgress');
            sessionStorage.removeItem('assessmentProgress');
            
            showQuestion(currentQuestion);
            updateProgress();
            showSuccess('All answers cleared. Starting fresh.');
        }
    };
    </script>
</body>
</html>