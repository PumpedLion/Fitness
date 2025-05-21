<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.FitnessProfile" %>
<%@ page import="Model.GeneratedPlan" %>
<%@ page import="java.util.List" %>
<%
    String userName = (session != null && session.getAttribute("userName") != null)
                      ? (String) session.getAttribute("userName")
                      : "Guest";

    FitnessProfile profile = (FitnessProfile) session.getAttribute("fitnessProfile");
    List<GeneratedPlan> plans = (List<GeneratedPlan>) session.getAttribute("userPlans");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Fitness Dashboard | FitnessPro</title>
  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #0f172a;
      color: #f1f5f9;
    }

    .navbar {
      background-color: #1e293b;
      padding: 15px 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .navbar a {
      color: #c084fc;
      font-size: 22px;
      font-weight: bold;
      text-decoration: none;
    }

    .navbar .right {
      color: #e2e8f0;
      font-size: 16px;
    }

    .navbar .right span {
      margin-right: 15px;
    }

    .navbar .right a {
      color: #e2e8f0;
      font-size: 16px;
      text-decoration: none;
      padding: 5px 10px;
      border-radius: 4px;
      transition: background-color 0.3s;
    }

    .navbar .right a:hover {
      background-color: #334155;
    }

    .container {
      max-width: 1100px;
      margin: 40px auto;
      padding: 0 20px;
    }

    h1 {
      font-size: 32px;
      color: #c084fc;
      margin-bottom: 30px;
    }

    .dashboard-grid {
      display: flex;
      gap: 30px;
      flex-wrap: wrap;
    }

    .card {
      background-color: #1e293b;
      padding: 25px;
      border-radius: 12px;
      flex: 1;
      min-width: 300px;
      box-sizing: border-box;
    }

    .card h2 {
      font-size: 20px;
      color: #c084fc;
      margin-bottom: 5px;
    }

    .card p.subtitle {
      color: #94a3b8;
      margin-bottom: 20px;
      font-size: 14px;
    }

    .info-group {
      margin-bottom: 12px;
    }

    .info-group span.label {
      display: block;
      color: #94a3b8;
      font-size: 14px;
    }

    .info-group span.value {
      font-weight: bold;
      font-size: 16px;
      color: #f8fafc;
    }

    .btn {
      background-color: #a855f7;
      color: white;
      padding: 10px 20px;
      border: none;
      border-radius: 8px;
      font-weight: bold;
      cursor: pointer;
      font-size: 14px;
      margin-top: 15px;
      transition: background-color 0.3s ease;
    }

    .btn:hover {
      background-color: #9333ea;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      font-weight: bold;
      margin-bottom: 8px;
    }

    .form-group input, 
    .form-group select {
      width: 100%;
      padding: 10px;
      border-radius: 6px;
      border: none;
      background-color: #334155;
      color: #f1f5f9;
    }

    .footer {
      text-align: center;
      margin-top: 60px;
      color: #94a3b8;
      font-size: 14px;
    }

    /* Toggleable Edit Profile Form */
    .edit-profile-form {
      display: none;
      margin-top: 20px;
      padding: 20px;
      background: #1e293b;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    }

    .edit-profile-form .form-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
    }

    .cancel-btn {
      background: #334155;
      color: #e2e8f0;
      border: none;
      padding: 8px 16px;
      border-radius: 4px;
      cursor: pointer;
    }

    .cancel-btn:hover {
      background: #475569;
    }

    /* Logout Modal Styles */
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
      color: #c084fc;
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
      color: #c084fc;
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

    .generate-plan-btn {
      background-color: #10b981;
      color: white;
      padding: 12px 24px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-size: 16px;
      font-weight: bold;
      margin-bottom: 30px;
      transition: background-color 0.3s;
    }

    .generate-plan-btn:hover {
      background-color: #059669;
    }

    /* Edit Profile Form Styles */
    .edit-profile-form {
      display: none;
      margin-top: 20px;
      padding: 20px;
      background: #1e293b;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    }

    .form-group {
      margin-bottom: 15px;
    }

    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: 500;
      color: #e2e8f0;
    }

    .form-group input,
    .form-group select {
      width: 100%;
      padding: 8px 12px;
      border: 1px solid #334155;
      border-radius: 4px;
      font-size: 14px;
      background-color: #334155;
      color: #f1f5f9;
    }

    .form-group input:focus,
    .form-group select:focus {
      outline: none;
      border-color: #c084fc;
    }

    .form-actions {
      display: flex;
      gap: 10px;
      margin-top: 20px;
    }

    .cancel-btn {
      background: #334155;
      color: #e2e8f0;
      border: none;
      padding: 8px 16px;
      border-radius: 4px;
      cursor: pointer;
    }

    .cancel-btn:hover {
      background: #475569;
    }
  </style>
</head>
<body>

  <div class="navbar">
    <a href="#">FitnessPro</a>
    <div class="right">
      <span><%= userName %></span>
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
    <h1>Welcome, <%= userName %></h1>
    
    <div class="dashboard-grid">
      <!-- Fitness Profile Card -->
      <div class="card">
        <h2>Fitness Profile</h2>
        <p class="subtitle">Your current fitness information</p>
        <% if (profile != null) { %>
          <div class="info-group">
            <span class="label">Age</span>
            <span class="value"><%= profile.getAge() %></span>
          </div>
          <div class="info-group">
            <span class="label">Gender</span>
            <span class="value"><%= profile.getGender() %></span>
          </div>
          <div class="info-group">
            <span class="label">Height</span>
            <span class="value"><%= profile.getHeight() %> cm</span>
          </div>
          <div class="info-group">
            <span class="label">Weight</span>
            <span class="value"><%= profile.getWeight() %> kg</span>
          </div>
          <div class="info-group">
            <span class="label">Activity Level</span>
            <span class="value"><%= profile.getActivityLevel() %></span>
          </div>
          <div class="info-group">
            <span class="label">Goals</span>
            <span class="value"><%= profile.getGoal() %></span>
          </div>
          <% if (profile.getHealthIssues() != null && !profile.getHealthIssues().isEmpty()) { %>
            <div class="info-group">
              <span class="label">Health Issues</span>
              <span class="value"><%= profile.getHealthIssues() %></span>
            </div>
          <% } %>
          <% if (profile.getDietaryRestrictions() != null && !profile.getDietaryRestrictions().isEmpty()) { %>
            <div class="info-group">
              <span class="label">Dietary Restrictions</span>
              <span class="value"><%= profile.getDietaryRestrictions() %></span>
            </div>
          <% } %>
        <% } else { %>
          <p>No profile information available. Please complete your profile.</p>
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
              <select name="goal" required>
                <option value="Weight Loss" <%= (profile != null && "Weight Loss".equals(profile.getGoal())) ? "selected" : "" %>>Weight Loss</option>
                <option value="Muscle Gain" <%= (profile != null && "Muscle Gain".equals(profile.getGoal())) ? "selected" : "" %>>Muscle Gain</option>
                <option value="Maintenance" <%= (profile != null && "Maintenance".equals(profile.getGoal())) ? "selected" : "" %>>Maintenance</option>
                <option value="General Fitness" <%= (profile != null && "General Fitness".equals(profile.getGoal())) ? "selected" : "" %>>General Fitness</option>
              </select>
            </div>

            <div class="form-group">
              <label>Health Issues (Optional)</label>
              <input type="text" name="health_issues" value="<%= (profile != null) ? profile.getHealthIssues() : "" %>">
            </div>

            <div class="form-group">
              <label>Dietary Restrictions (Optional)</label>
              <input type="text" name="dietary_restrictions" value="<%= (profile != null) ? profile.getDietaryRestrictions() : "" %>">
            </div>

            <div class="form-actions">
              <button type="submit" class="btn">Save Changes</button>
              <button type="button" class="cancel-btn" onclick="toggleEditForm()">Cancel</button>
            </div>
          </form>
        </div>
      </div>

      <!-- Generate Plan Card -->
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
      <h2 style="color: #c084fc; margin-bottom: 20px;">Your Fitness Plans</h2>
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

  <div class="footer">
    &copy; 2025 FitnessPro. All rights reserved.
  </div>

  <script type="text/javascript">
    // Profile Edit Functions
    function toggleEditForm() {
      const form = document.getElementById('editForm');
      if (form.style.display === 'none' || form.style.display === '') {
        form.style.display = 'block';
      } else {
        form.style.display = 'none';
      }
    }

    // Plan Generation Functions
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
      .then(response => response.json())
      .then(data => {
        if (data.status === 'success') {
          statusDiv.textContent = 'Plan generated successfully!';
          statusDiv.style.color = '#22c55e';
          setTimeout(() => {
            window.location.reload();
          }, 1500);
        } else {
          statusDiv.textContent = 'Error: ' + data.message;
          statusDiv.style.color = '#ef4444';
        }
      })
      .catch(error => {
        console.error('Error:', error);
        statusDiv.textContent = 'Error: ' + error.message;
        statusDiv.style.color = '#ef4444';
      });
    }

    // Plan Deletion Function
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

    // Add event listeners when the page loads
    document.addEventListener('DOMContentLoaded', function() {
      // Add enter key support for plan generation
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
  </script>
</body>
</html>
