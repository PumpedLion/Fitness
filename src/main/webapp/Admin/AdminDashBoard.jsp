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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FitnessPro - Admin Dashboard</title>
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
            padding: 10px 20px;
        }
        .navbar .logo {
            color: #A855F7;
            font-weight: bold;
            font-size: 20px;
        }
        .navbar .links {
            display: flex;
            gap: 15px;
        }
        .navbar .links a {
            color: #FFFFFF;
            text-decoration: none;
            font-size: 14px;
        }
        .container {
            padding: 20px 40px;
        }
        h1 {
            color: #A855F7;
        }
        .dashboard {
            display: flex;
            gap: 20px;
            margin-top: 20px;
        }
        .card {
            background-color: #1E293B;
            padding: 20px;
            border-radius: 8px;
            flex: 1;
        }
        .card h2 {
            color: #A855F7;
            font-size: 18px;
            margin-bottom: 10px;
        }
        .card p {
            margin: 8px 0;
        }
        .btn {
            background-color: #A855F7;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #9333EA;
        }
        .inputField {
            width: 100%;
            padding: 8px;
            margin-top: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
            border: none;
        }
        .edit-profile-form {
            display: none;
            margin-top: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input, 
        .form-group select {
            width: 100%;
            padding: 8px;
            border-radius: 4px;
            border: none;
            background-color: #334155;
            color: #FFFFFF;
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
            overflow: hidden;
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
            background-color: #1e293b;
            padding: 15px;
            border-radius: 6px;
            overflow-x: auto;
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
        <div class="logo">FitnessPro</div>
        <div class="links">
            <a href="AdminPanel.jsp">Admin Profile</a>
            
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
        <h1>Your Fitness Dashboard</h1>
        <div class="dashboard">
            <div class="card">
                <h2>Your Fitness Profile</h2>
                <% if (profile != null) { %>
                    <p><strong>Age:</strong> <%= profile.getAge() %> years</p>
                    <p><strong>Gender:</strong> <%= profile.getGender() %></p>
                    <p><strong>Height:</strong> <%= profile.getHeight() %> cm</p>
                    <p><strong>Weight:</strong> <%= profile.getWeight() %> kg</p>
                    <p><strong>Activity Level:</strong> <%= profile.getActivityLevel() %></p>
                    <p><strong>Fitness Goals:</strong> <%= profile.getGoal() %></p>
                    <% if (profile.getHealthIssues() != null && !profile.getHealthIssues().isEmpty()) { %>
                        <p><strong>Health Issues:</strong> <%= profile.getHealthIssues() %></p>
                    <% } %>
                    <% if (profile.getDietaryRestrictions() != null && !profile.getDietaryRestrictions().isEmpty()) { %>
                        <p><strong>Dietary Restrictions:</strong> <%= profile.getDietaryRestrictions() %></p>
                    <% } %>
                <% } else { %>
                    <p>No profile data found.</p>
                <% } %>
                <button class="btn" onclick="toggleEditForm()">Edit Profile</button>

                <!-- Edit Profile Form (Hidden by Default) -->
                <div class="edit-profile-form" id="editForm">
                    <form action="../FitnessProfileServlet" method="post">
                        <div class="form-group">
                            <label>Age</label>
                            <input type="number" name="age" value="<%= (profile != null) ? profile.getAge() : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label>Gender</label>
                            <select name="gender" required>
                                <option value="Male" <%= (profile != null && "Male".equals(profile.getGender())) ? "selected" : "" %>>Male</option>
                                <option value="Female" <%= (profile != null && "Female".equals(profile.getGender())) ? "selected" : "" %>>Female</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Height (cm)</label>
                            <input type="number" name="height" value="<%= (profile != null) ? profile.getHeight() : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label>Weight (kg)</label>
                            <input type="number" name="weight" value="<%= (profile != null) ? profile.getWeight() : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label>Activity Level</label>
                            <select name="activity_level" required>
                                <option value="Sedentary" <%= (profile != null && "Sedentary".equals(profile.getActivityLevel())) ? "selected" : "" %>>Sedentary</option>
                                <option value="Light Activity" <%= (profile != null && "Light Activity".equals(profile.getActivityLevel())) ? "selected" : "" %>>Light Activity</option>
                                <option value="Moderate" <%= (profile != null && "Moderate".equals(profile.getActivityLevel())) ? "selected" : "" %>>Moderate</option>
                                <option value="Very Active" <%= (profile != null && "Very Active".equals(profile.getActivityLevel())) ? "selected" : "" %>>Very Active</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Fitness Goal</label>
                            <input type="text" name="goal" value="<%= (profile != null) ? profile.getGoal() : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label>Health Issues (Optional)</label>
                            <input type="text" name="health_issues" value="<%= (profile != null) ? profile.getHealthIssues() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Dietary Restrictions (Optional)</label>
                            <input type="text" name="dietary_restrictions" value="<%= (profile != null) ? profile.getDietaryRestrictions() : "" %>">
                        </div>

                        <button type="submit" class="btn">Save Profile</button>
                        <button type="button" class="btn" onclick="toggleEditForm()">Cancel</button>
                    </form>
                </div>
            </div>

            <div class="card">
                <h2>Generate Plan</h2>
                <p class="subtitle">Create a personalized workout and meal plan</p>
                <div class="form-group">
                    <label for="planTitle">Plan Title</label>
                    <input type="text" id="planTitle" placeholder="Enter a title for your plan">
                </div>
                <button class="btn" onclick="generatePlan()">Generate Plan</button>
                <div id="planStatus" style="margin-top: 15px; color: #94a3b8;"></div>
            </div>
        </div>

        <!-- Plans Section -->
        <div class="plans-section" style="margin-top: 40px;">
            <h2 style="color: #A855F7; margin-bottom: 20px;">Your Fitness Plans</h2>
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
                    <div class="card">
                        <h2>No Plans Yet</h2>
                        <p>Use the "Generate Plan" section above to create your first personalized fitness plan!</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function toggleEditForm() {
            const form = document.getElementById("editForm");
            form.style.display = (form.style.display === "none" || form.style.display === "") ? "block" : "none";
        }

        function generatePlan() {
            const planTitle = document.getElementById('planTitle').value;
            const statusDiv = document.getElementById('planStatus');
            
            if (!planTitle.trim()) {
                statusDiv.textContent = 'Please enter a plan title';
                statusDiv.style.color = '#ef4444';
                return;
            }
            
            statusDiv.textContent = 'Generating plan...';
            statusDiv.style.color = '#94a3b8';
            
            fetch('../MealPlanServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=generate&title=' + encodeURIComponent(planTitle)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.status === 'success') {
                    statusDiv.textContent = 'Plan generated successfully!';
                    statusDiv.style.color = '#22c55e';
                    // Update the plans display with the new data
                    updatePlansDisplay(data.plans);
                    // Clear the title input
                    document.getElementById('planTitle').value = '';
                } else {
                    statusDiv.textContent = 'Error: ' + data.message;
                    statusDiv.style.color = '#ef4444';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                statusDiv.textContent = 'Error generating plan. Please try again.';
                statusDiv.style.color = '#ef4444';
            });
        }

        function updatePlansDisplay(plans) {
            const plansContainer = document.querySelector('.plans-container');
            if (!plans || plans.length === 0) {
                plansContainer.innerHTML = `
                    <div class="card">
                        <h2>No Plans Yet</h2>
                        <p>Use the "Generate Plan" section above to create your first personalized fitness plan!</p>
                    </div>
                `;
                return;
            }

            let plansHTML = '';
            plans.forEach(plan => {
                // Properly escape the plan content for HTML display
                const workoutPlan = plan.workoutPlan ? plan.workoutPlan.replace(/"/g, '&quot;').replace(/\n/g, '<br>') : '';
                const mealPlan = plan.mealPlan ? plan.mealPlan.replace(/"/g, '&quot;').replace(/\n/g, '<br>') : '';
                
                plansHTML += `
                    <div class="plan-card" data-plan-id="${plan.id}">
                        <div class="plan-header">
                            <h2 class="plan-title">${plan.title}</h2>
                            <div>
                                <span class="plan-date">Created: ${plan.createdAt}</span>
                                <button class="delete-plan-btn" onclick="deletePlan(${plan.id})">Delete Plan</button>
                            </div>
                        </div>
                        <div class="plan-content">
                            <div class="plan-section">
                                <h3>Workout Plan</h3>
                                <pre>${workoutPlan}</pre>
                            </div>
                            <div class="plan-section">
                                <h3>Meal Plan</h3>
                                <pre>${mealPlan}</pre>
                            </div>
                        </div>
                    </div>
                `;
            });
            plansContainer.innerHTML = plansHTML;
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

        document.addEventListener('DOMContentLoaded', function() {
            const planTitleInput = document.getElementById('planTitle');
            if (planTitleInput) {
                planTitleInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        generatePlan();
                    }
                });
            }
        });

        // Logout Modal Functions
        function showLogoutModal() {
            document.getElementById('logoutModal').style.display = 'block';
        }

        function closeLogoutModal() {
            document.getElementById('logoutModal').style.display = 'none';
        }

        function confirmLogout() {
            window.location.href = '../UserLogoutServlet';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('logoutModal');
            if (event.target == modal) {
                closeLogoutModal();
            }
        }
    </script>

</body>
</html>
