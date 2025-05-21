<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Model.FitnessProfile" %>
<%@ page import="Model.GeneratedPlan" %>
<%@ page import="java.util.List" %>
<%@ page import="DAO.GeneratedPlanDAO" %>
<%
    String userName = (session != null && session.getAttribute("userName") != null)
                      ? (String) session.getAttribute("userName")
                      : "Guest";
    FitnessProfile profile = (FitnessProfile) session.getAttribute("fitnessProfile");
    List<GeneratedPlan> plans = (List<GeneratedPlan>) session.getAttribute("userPlans");
    
    // If plans are not in session, try to get them from the database
    if (plans == null) {
        try {
            GeneratedPlanDAO planDAO = new GeneratedPlanDAO();
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                plans = planDAO.getPlansByUserId(userId);
                session.setAttribute("userPlans", plans);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Calculate BMI if profile exists
    double bmi = 0;
    String bmiCategory = "";
    String bmiClass = "";
    if (profile != null) {
        // Convert height from cm to m and calculate BMI
        double heightInMeters = profile.getHeight() / 100.0;
        bmi = profile.getWeight() / (heightInMeters * heightInMeters);
        
        // Determine BMI category
        if (bmi < 18.5) {
            bmiCategory = "Underweight";
            bmiClass = "bmi-underweight";
        } else if (bmi < 25) {
            bmiCategory = "Normal";
            bmiClass = "bmi-normal";
        } else if (bmi < 30) {
            bmiCategory = "Overweight";
            bmiClass = "bmi-overweight";
        } else {
            bmiCategory = "Obese";
            bmiClass = "bmi-obese";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Profile</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #0F172A;
            font-family: Arial, sans-serif;
            color: #FFFFFF;
        }

        .navbar {
            background-color: #1E293B;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 24px;
        }

        .navbar .logo {
            color: #A855F7;
            font-weight: bold;
            font-size: 20px;
        }

        .navbar .links {
            display: flex;
            gap: 16px;
        }

        .navbar .links a {
            color: #FFFFFF;
            text-decoration: none;
            padding: 6px 12px;
        }

        .navbar .links a.active {
            background-color: #A855F7;
            border-radius: 4px;
        }

        .navbar .user-badge {
            background-color: #A855F7;
            padding: 2px 6px;
            font-size: 12px;
            border-radius: 4px;
            margin-left: 5px;
        }

        .container {
            padding: 40px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        .card {
            background-color: #1E293B;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.4);
        }

        .card h2 {
            color: #A855F7;
            margin-bottom: 10px;
        }

        .card .section {
            background-color: #334155;
            border-radius: 6px;
            padding: 16px;
            margin-top: 10px;
        }

        .section h3 {
            color: #FFFFFF;
            margin: 0 0 10px;
        }

        .info-item {
            margin-bottom: 6px;
        }

        .info-label {
            color: #94A3B8;
            font-weight: bold;
        }

        .info-value {
            margin-left: 10px;
            color: #FFFFFF;
        }

        .tag {
            background-color: #A855F7;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
            display: inline-block;
            margin-right: 6px;
        }

        .bmi-normal {
            color: #4ADE80; /* green */
        }

        .bmi-underweight {
            color: #FBBF24; /* yellow */
        }

        .bmi-overweight {
            color: #F87171; /* red */
        }

        .bmi-obese {
            color: #EF4444; /* dark red */
        }

        .button-purple {
            background-color: #A855F7;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 10px;
        }

        .button-green {
            background-color: #22C55E;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 10px;
        }

        .generated-plans {
            grid-column: span 2;
        }

        .note {
            color: #CBD5E1;
            font-style: italic;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #1E293B;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #334155;
            border-radius: 8px;
            width: 300px;
            text-align: center;
            color: white;
        }

        .modal-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .confirm-btn {
            background-color: #EF4444;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .confirm-btn:hover {
            background-color: #DC2626;
        }

        .cancel-btn {
            background-color: #334155;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .cancel-btn:hover {
            background-color: #475569;
        }

        /* Plan Card Styles */
        .plan-card {
            background-color: #1e293b;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .plan-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .plan-title {
            font-size: 24px;
            color: #A855F7;
            margin: 0;
        }

        .plan-date {
            color: #94a3b8;
            font-size: 14px;
        }

        .plan-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 20px;
        }

        .plan-section {
            background-color: #334155;
            padding: 15px;
            border-radius: 8px;
        }

        .plan-section h3 {
            color: #A855F7;
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .plan-section pre {
            color: #e2e8f0;
            white-space: pre-wrap;
            font-family: inherit;
            margin: 0;
            font-size: 14px;
            line-height: 1.5;
        }

        .delete-plan-btn {
            background-color: #ef4444;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .delete-plan-btn:hover {
            background-color: #dc2626;
        }

    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Admin Panel</div>
    <div class="links">
        <a href="AdminDashBoard.jsp">Return to Dashboard</a>
        <a href="Statistics.jsp">Statistics</a>
        <a href="Manage.jsp">Manage Users</a>
        <a href="AdminPanel.jsp" class="active">Admin Profile</a>
        <a href="CreateAdmin.jsp">Create Admin</a>
        <a href="#"><%= userName %> <span class="user-badge">Admin</span></a>
        <a href="#" onclick="showLogoutModal(); return false;">Logout</a>
    </div>
</div>

<!-- Logout Modal -->
<div id="logoutModal" class="modal">
    <div class="modal-content">
        <h2>Confirm Logout</h2>
        <p>Are you sure you want to logout?</p>
        <div class="modal-buttons">
            <button onclick="confirmLogout()" class="confirm-btn">Yes, Logout</button>
            <button onclick="closeLogoutModal()" class="cancel-btn">Cancel</button>
        </div>
    </div>
</div>

<div class="container">
    <!-- Left Column: Admin Profile -->
    <div class="card">
        <h2>Admin Profile</h2>
        <p>Update your profile details</p>
        <div class="section">
            <h3>Admin Profile</h3>
            <div class="info-item"><span class="info-label">Name:</span> <span class="info-value"><%= userName %></span></div>
            <div class="info-item"><span class="info-label">Access Level:</span> <span class="info-value">Administrator</span></div>
            <div class="info-item"><span class="info-label">Department:</span> <span class="info-value">Fitness Management</span></div>
            <div class="info-item"><span class="info-label">Permissions:</span> <span class="info-value">Full Access</span></div>
            
        </div>
    </div>

    <!-- Right Column: Fitness Profile -->
    <div class="card">
        <h2>Fitness Profile</h2>
        <p>Your fitness details</p>

        <% if (profile != null) { %>
            <div class="section">
                <h3>Personal Information</h3>
                <div class="info-item"><span class="info-label">Age:</span> <span class="info-value"><%= profile.getAge() %> years</span></div>
                <div class="info-item"><span class="info-label">Gender:</span> <span class="info-value"><%= profile.getGender() %></span></div>
                <div class="info-item"><span class="info-label">Height:</span> <span class="info-value"><%= profile.getHeight() %> cm</span></div>
                <div class="info-item"><span class="info-label">Weight:</span> <span class="info-value"><%= profile.getWeight() %> kg</span></div>
                <div class="info-item"><span class="info-label">BMI:</span> <span class="info-value <%= bmiClass %>"><%= String.format("%.1f", bmi) %> (<%= bmiCategory %>)</span></div>
            </div>

            <div class="section">
                <h3>Fitness Details</h3>
                <div class="info-item"><span class="info-label">Activity Level:</span> <span class="info-value"><%= profile.getActivityLevel() %></span></div>
                <div class="info-item"><span class="info-label">Fitness Goals:</span> 
                    <% 
                    String[] goals = profile.getGoal().split(",");
                    for (String goal : goals) {
                    %>
                        <span class="tag"><%= goal.trim() %></span>
                    <% } %>
                </div>
                <button class="button-purple" onclick="window.location.href='AdminDashBoard.jsp'">Edit Profile</button>
            </div>

            <div class="section">
                <h3>Health Information</h3>
                <div class="info-item">
                    <span class="info-label">Health Issues:</span> 
                    <span class="info-value">
                        <% if (profile.getHealthIssues() != null && !profile.getHealthIssues().isEmpty()) { %>
                            <%= profile.getHealthIssues() %>
                        <% } else { %>
                            <span class="note">None specified</span>
                        <% } %>
                    </span>
                </div>
            </div>

            <div class="section">
                <h3>Dietary Information</h3>
                <div class="info-item">
                    <span class="info-label">Dietary Restrictions:</span> 
                    <span class="info-value">
                        <% if (profile.getDietaryRestrictions() != null && !profile.getDietaryRestrictions().isEmpty()) { %>
                            <%= profile.getDietaryRestrictions() %>
                        <% } else { %>
                            <span class="note">None specified</span>
                        <% } %>
                    </span>
                </div>
            </div>
        <% } else { %>
            <div class="section">
                <p class="note">No fitness profile found. Please create your profile first.</p>
                <button class="button-purple" onclick="window.location.href='../View/SaveProfile.jsp'">Create Profile</button>
            </div>
        <% } %>
    </div>

    <!-- Bottom Row: Generated Plans -->
    <div class="card generated-plans">
        <h2>Generated Plans</h2>
        <div class="plans-container">
            <% if (plans != null && !plans.isEmpty()) { %>
                <% for (GeneratedPlan plan : plans) { %>
                    <div class="plan-card">
                        <div class="plan-header">
                            <h2 class="plan-title"><%= plan.getTitle() %></h2>
                            <div>
                                <span class="plan-date">Created: <%= plan.getCreatedAt() %></span>
                                <button class="delete-plan-btn" onclick="deletePlan(<%= plan.getId() %>)">Delete Plan</button>
                            </div>
                        </div>
                        <div class="plan-content">
                            <div class="plan-section">
                                <h3>Workout Plan</h3>
                                <pre><%= plan.getWorkoutPlan() %></pre>
                            </div>
                            <div class="plan-section">
                                <h3>Meal Plan</h3>
                                <pre><%= plan.getMealPlan() %></pre>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="info-item note">No fitness plans generated yet</div>
                <button class="button-purple" onclick="window.location.href='AdminDashBoard.jsp'">Generate Your First Plan</button>
            <% } %>
        </div>
        <button class="button-green" onclick="window.location.href='AdminDashBoard.jsp'" style="margin-top: 20px;">🏠 Return to Dashboard</button>
    </div>
</div>

<script>
    // Logout Modal Functions
    function showLogoutModal() {
        document.getElementById('logoutModal').style.display = 'block';
    }

    function closeLogoutModal() {
        document.getElementById('logoutModal').style.display = 'none';
    }

    function confirmLogout() {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/UserLogoutServlet';
        document.body.appendChild(form);
        form.submit();
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('logoutModal');
        if (event.target == modal) {
            closeLogoutModal();
        }
    }

    function deletePlan(planId) {
        if (confirm('Are you sure you want to delete this plan?')) {
            fetch('../MealPlanServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=delete&planId=' + planId
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    // Remove the deleted plan from the display
                    const planCard = document.querySelector(`[data-plan-id="${planId}"]`);
                    if (planCard) {
                        planCard.remove();
                    }
                    // Reload the page to refresh the plans list
                    window.location.reload();
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while deleting the plan');
            });
        }
    }
</script>

</body>
</html>
