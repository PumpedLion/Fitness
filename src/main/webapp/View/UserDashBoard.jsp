<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.FitnessProfile" %>
<%
    String userName = (session != null && session.getAttribute("userName") != null)
                      ? (String) session.getAttribute("userName")
                      : "Guest";

    FitnessProfile profile = (FitnessProfile) session.getAttribute("fitnessProfile");
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
    }

    .edit-profile-form .form-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
    }

    .cancel-btn {
      background: none;
      border: none;
      color: #94a3b8;
      font-size: 14px;
      cursor: pointer;
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

  <div class="container">
    <h1>Your Fitness Dashboard</h1>

    <div class="dashboard-grid">

      <!-- Left Profile Card -->
      <div class="card">
        <h2>Your Fitness Profile</h2>
        <p class="subtitle">Your personal information used to generate plans</p>

        <% if (profile != null) { %>
          <div class="info-group">
            <span class="label">Age</span>
            <span class="value"><%= profile.getAge() %> years</span>
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
            <span class="label">Fitness Goals</span>
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
          <p>No profile data found.</p>
        <% } %>

        <button class="btn" onclick="toggleEditForm()">Edit Profile</button>

        <!-- Edit Profile Form (Hidden by Default) -->
        <div class="edit-profile-form" id="editForm">
          <form action="FitnessProfileServlet" method="post">
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

            <div class="form-actions">
              <button type="submit" class="btn">Save Profile</button>
              <button type="button" class="cancel-btn" onclick="toggleEditForm()">Cancel</button>
            </div>
          </form>
        </div>
      </div>

      <!-- Right Plan Generator -->
      <div class="card">
        <h2>Generate New Plan</h2>
        <p class="subtitle">Create a personalized fitness and meal plan based on your profile</p>
        <form>
          <div class="form-group">
            <label for="plan-title">Plan Title (Optional)</label>
            <input type="text" id="plan-title" placeholder="Enter a title for your plan">
          </div>
          <button class="btn" type="submit">Generate New Plan</button>
        </form>
      </div>

    </div>
  </div>

  <div class="footer">
    &copy; 2025 FitnessPro. All rights reserved.
  </div>

  <script>
    function toggleEditForm() {
      const form = document.getElementById("editForm");
      form.style.display = (form.style.display === "none" || form.style.display === "") ? "block" : "none";
    }
  </script>

  <script src="../Assets/js/logout.js"></script>
</body>
</html>
