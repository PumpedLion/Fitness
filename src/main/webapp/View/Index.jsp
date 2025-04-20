<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitnessPro - Your AI Fitness Companion</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background: linear-gradient(to bottom, #2a0d50, #0f172a);
            color: white;
        }
        .container {
            text-align: center;
            padding: 80px 20px 40px;
        }
        .container h1 {
            font-size: 3em;
            font-weight: bold;
            margin: 0;
        }
        .container h1 .highlight {
            color: #c084fc;
        }
        .subheading {
            margin-top: 20px;
            font-size: 1.2em;
            color: #cbd5e1;
        }
        .button-group {
            margin-top: 30px;
        }
        .button-group button {
            padding: 12px 24px;
            margin: 0 10px;
            border-radius: 6px;
            font-weight: bold;
            border: none;
            cursor: pointer;
            font-size: 1em;
        }
        .user-login { background-color: #a855f7; color: white; }
        .signup { background-color: transparent; border: 2px solid #a855f7; color: #a855f7; }
        .admin-login { background-color: #1e293b; color: white; }
        .features-section {
            background-color: #1e293b;
            padding: 60px 20px;
            text-align: center;
        }
        .features-section h2 { font-size: 2.2em; margin-bottom: 10px; }
        .features-section p { margin-bottom: 40px; color: #cbd5e1; }
        .features {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
        }
        .feature-card {
            background-color: #334155;
            padding: 30px;
            border-radius: 12px;
            width: 280px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }
        .feature-card i { font-size: 2.5em; color: #a855f7; margin-bottom: 15px; }
        .feature-card h3 { margin-bottom: 10px; }
        .feature-card p { color: #94a3b8; }
        .modal-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.85);
            display: flex; align-items: center; justify-content: center;
            z-index: 1000; display: none;
        }
        .modal {
            background-color: #1e293b;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            width: 90%; max-width: 400px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.6);
            animation: fadeIn 0.3s ease-out;
        }
        .modal input {
            width: 90%;
            padding: 12px;
            margin: 10px 0;
            border: none;
            border-radius: 6px;
            background: #334155;
            color: white;
        }
        .modal button {
            padding: 12px 24px;
            background-color: #a855f7;
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
        }
        .close-btn {
            background: transparent;
            border: none;
            color: #cbd5e1;
            font-size: 1.2em;
            float: right;
            cursor: pointer;
        }
        .toggle-admin {
            color: #c084fc;
            cursor: pointer;
            text-decoration: underline;
            margin-top: 10px;
            display: inline-block;
        }
        .error-msg {
            color: #f87171;
            margin-top: 10px;
            font-size: 0.9em;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<!-- Landing Page -->
<div class="container">
    <h1><span class="highlight">FitnessPro</span> <br> Your AI Fitness Companion</h1>
    <p class="subheading">
        Get personalized workout and meal plans based on your fitness profile, powered by advanced AI technology.
    </p>
    <div class="button-group">
        <button class="user-login" onclick="openModal('user')">User Login</button>
        <button class="signup" onclick="openModal('signup')">Sign Up</button>
        <button class="admin-login" onclick="openModal('admin')">Admin Login</button>
    </div>
</div>

<!-- Features Section -->
<div class="features-section">
    <h2>Features</h2>
    <p>Everything you need to reach your fitness goals</p>
    <div class="features">
        <div class="feature-card">
            <i class="fas fa-dumbbell"></i>
            <h3>AI-Generated Workout Plans</h3>
            <p>Get personalized workout routines tailored to your fitness level, goals, and preferences.</p>
        </div>
        <div class="feature-card">
            <i class="fas fa-apple-alt"></i>
            <h3>Nutrition Planning</h3>
            <p>Custom meal plans based on your dietary restrictions, caloric needs, and fitness objectives.</p>
        </div>
        <div class="feature-card">
            <i class="fas fa-clipboard-list"></i>
            <h3>Progress Tracking</h3>
            <p>Keep track of your fitness journey with detailed plans and history.</p>
        </div>
    </div>
</div>

<!-- Modal Popup -->
<div id="modalOverlay" class="modal-overlay">
    <div id="modalBox" class="modal">
        <button class="close-btn" onclick="closeModal()">✖</button>
        <div id="modalContent"></div>
    </div>
</div>

<!-- FontAwesome -->
<script src="https://kit.fontawesome.com/a076d05399.js"></script>

<!-- Modal Logic -->
<script>
    function openModal(type) {
        const modal = document.getElementById('modalOverlay');
        const content = document.getElementById('modalContent');
        modal.style.display = 'flex';

        let errorMessage = `<%= error != null && error.equals("wrongkey") ? "<div class='error-msg'>Invalid Admin Key. Please try again.</div>" : "" %>`;

        if(type === 'user') {
            content.innerHTML = `
                <h2>User Login</h2>
                <form id="userLoginForm" action="${pageContext.request.contextPath}/UserLoginServlet" method="post">
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <button type="submit">Login</button>
                </form>`;
        } 
        else if(type === 'signup') {
            content.innerHTML = `
                <h2>User Sign Up</h2>
                <form id="signupForm" action="${pageContext.request.contextPath}/UserSignupServlet" method="post">
                    <input type="text" name="fullname" placeholder="Full Name" required>
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <span class="toggle-admin" onclick="toggleAdmin()">Show Admin Options</span>
                    <div id="adminKeyField" style="display:none; margin-top:10px;">
                        <input type="text" name="adminkey" placeholder="Enter Admin Key">
                    </div>
                    ${errorMessage}
                    <button type="submit">Sign Up</button>
                </form>`;
        } 
        else if(type === 'admin') {
            content.innerHTML = `
                <h2>Admin Login</h2>
                <form id="adminLoginForm" action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">
                    <input type="email" name="email" placeholder="Admin Email" required>
                    <input type="password" name="password" placeholder="Admin Password" required>
                    <button type="submit">Login</button>
                </form>`;
        }
    }

    function closeModal() {
        document.getElementById('modalOverlay').style.display = 'none';
    }

    function toggleAdmin() {
        const adminField = document.getElementById('adminKeyField');
        const toggleText = document.querySelector('.toggle-admin');
        if (adminField.style.display === 'none') {
            adminField.style.display = 'block';
            toggleText.textContent = 'Hide Admin Options';
        } else {
            adminField.style.display = 'none';
            toggleText.textContent = 'Show Admin Options';
        }
    }

    <% if ("wrongkey".equals(error)) { %>
        // Automatically open signup modal if wrongkey error.
        window.onload = function() {
            openModal('signup');
        }
    <% } %>
</script>

</body>
</html>
