<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - Statistics</title>
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
            padding: 6px 10px;
        }
        .navbar .links a.active {
            background-color: #A855F7;
            border-radius: 4px;
        }
        .container {
            padding: 20px 40px;
        }
        h1 {
            color: #A855F7;
        }
        .stats-grid {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background-color: #1E293B;
            padding: 20px;
            border-radius: 8px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .stat-card p {
            margin: 5px 0;
        }
        .stat-card .highlight {
            color: #22C55E;
            font-size: 12px;
        }
        .system-health, .quick-actions, .system-info {
            background-color: #1E293B;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .system-health h2,
        .quick-actions h2,
        .system-info h2 {
            color: #A855F7;
            margin-bottom: 15px;
        }
        .progress-bar {
            width: 100%;
            background-color: #334155;
            border-radius: 4px;
            overflow: hidden;
            height: 14px;
            margin: 8px 0;
        }
        .progress {
            height: 100%;
            background-color: #22C55E;
            width: 100%; /* 100% for complete profile completion */
        }
        .quick-actions a {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #FFFFFF;
            text-decoration: none;
            margin-bottom: 10px;
            padding: 8px;
            background: #334155;
            border-radius: 4px;
        }
        .system-info p {
            margin: 4px 0;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Admin Panel</div>
    <div class="links">
        <a href="AdminDashBoard.jsp">Return to Dashboard</a>
        <a href="Statistics.jsp" class="active">Statistics</a>
        <a href="Manage.jsp" >Manage Users</a>
        <a href="AdminPanel.jsp">Admin Profile</a>
        <a href="CreateAdmin.jsp">Create Admin</a>
        <a href="#">Johan <span class="user-badge">Admin</span></a>
        <a href="../View/index.jsp">Logout</a>
    </div>
</div>

<div class="container">
    <div class="stats-grid">
        <div class="stat-card">
            <p>Total Users</p>
            <h2>4</h2>
            <p class="highlight">+4 this week</p>
        </div>
        <div class="stat-card">
            <p>Total Plans</p>
            <h2>2</h2>
            <p class="highlight">+2 this week</p>
        </div>
        <div class="stat-card">
            <p>Admin Users</p>
            <h2>1</h2>
        </div>
    </div>

    <div class="system-health">
        <h2>System Health</h2>
        <p>User Profile Completion</p>
        <div class="progress-bar">
            <div class="progress"></div>
        </div>
        <p>4 profiles | Plans per User: <strong>0.5 avg. plans/user</strong></p>
    </div>

    <div class="stats-grid">
        <div class="quick-actions">
            <h2>Quick Actions</h2>
            <a href="#">➕ Create New Admin</a>
            <a href="#">👥 Manage Users</a>
            <a href="#">🏠 Return to Dashboard</a>
        </div>

        <div class="system-info">
            <h2>System Information</h2>
            <p><strong>Environment:</strong> development</p>
            <p><strong>Version:</strong> 1.0.0</p>
            <p><strong>Admin:</strong> johanwhite2024@gmail.com</p>
            <p><strong>Last Login:</strong> 4/19/2025</p>
        </div>
    </div>
</div>

</body>
</html>
