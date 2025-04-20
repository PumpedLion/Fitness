<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
        <a href="#">Johan <span class="user-badge">Admin</span></a>
        <a href="../View/index.jsp">Logout</a>
    </div>
</div>

<div class="container">
    <!-- Left Column: Admin Profile -->
    <div class="card">
        <h2>Admin Profile</h2>
        <p>Update your profile details</p>
        <div class="section">
            <h3>Admin Profile</h3>
            <div class="info-item"><span class="info-label">Access Level:</span> <span class="info-value">standard</span></div>
            <div class="info-item"><span class="info-label">Department:</span> <span class="info-value">general</span></div>
            <div class="info-item"><span class="info-label">Permissions:</span> <span class="info-value">No permissions assigned</span></div>
            <div class="info-item"><span class="info-label">Last Login:</span> <span class="info-value">4/19/2025, 8:51:52 PM</span></div>
            <button class="button-purple">Edit Profile</button>
        </div>
    </div>

    <!-- Right Column: Fitness Profile -->
    <div class="card">
        <h2>Fitness Profile</h2>
        <p>Your fitness details</p>

        <div class="section">
            <h3>Personal Information</h3>
            <div class="info-item"><span class="info-label">Age:</span> <span class="info-value">30 years</span></div>
            <div class="info-item"><span class="info-label">Gender:</span> <span class="info-value">Male</span></div>
            <div class="info-item"><span class="info-label">Height:</span> <span class="info-value">170 cm</span></div>
            <div class="info-item"><span class="info-label">Weight:</span> <span class="info-value">70 kg</span></div>
            <div class="info-item"><span class="info-label">BMI:</span> <span class="info-value bmi-normal">24.2 (Normal)</span></div>
        </div>

        <div class="section">
            <h3>Fitness Details</h3>
            <div class="info-item"><span class="info-label">Activity Level:</span> <span class="info-value">Moderate</span></div>
            <div class="info-item"><span class="info-label">Fitness Goals:</span> 
                <span class="tag">Weight Loss</span>
                <span class="tag">Improved Fitness</span>
                <span class="tag">Improved Flexibility</span>
            </div>
            <button class="button-purple">Edit Profile</button>
        </div>

        <div class="section">
            <h3>Health Information</h3>
            <div class="info-item"><span class="info-label">Health Issues:</span> <span class="info-value note">None specified</span></div>
        </div>

        <div class="section">
            <h3>Dietary Information</h3>
            <div class="info-item"><span class="info-label">Dietary Restrictions:</span> <span class="info-value note">None specified</span></div>
        </div>
    </div>

    <!-- Bottom Row: Generated Plans -->
    <div class="card generated-plans">
        <h2>Generated Plans</h2>
        <div class="info-item note">No fitness plans generated yet</div>
        <button class="button-purple">Generate Your First Plan</button>
        <button class="button-green">🏠 Return to Dashboard</button>
    </div>
</div>

</body>
</html>
