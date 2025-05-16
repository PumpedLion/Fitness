<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Model.FitnessProfile" %>
<%
    String userName = (session != null && session.getAttribute("userName") != null)
                      ? (String) session.getAttribute("userName")
                      : "Guest";
    FitnessProfile profile = (FitnessProfile) session.getAttribute("fitnessProfile");
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
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo">FitnessPro</div>
        <div class="links">
            <a href="AdminPanel.jsp">Admin Profile</a>
            <a href="CreateAdmin.jsp">Create Admin</a>
            <a href="#"><%= userName %> <span class="user-badge">Admin</span></a>
            <a href="#" onclick="showLogoutModal(); return false;">Logout</a>
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
                <h2>Generate New Plan</h2>
                <p>Create a personalized fitness and meal plan based on your profile</p>
                <input type="text" class="inputField" placeholder="Enter a title for your plan (optional)">
                <button class="btn">Generate New Plan</button>
            </div>
        </div>
    </div>

    <script>
        function toggleEditForm() {
            const form = document.getElementById("editForm");
            form.style.display = (form.style.display === "none" || form.style.display === "") ? "block" : "none";
        }
    </script>

    <script src="../js/logout.js"></script>

</body>
</html>
