<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Admin Panel</title>
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
        .navbar .user-badge {
            background-color: #A855F7;
            padding: 2px 5px;
            font-size: 12px;
            border-radius: 4px;
            margin-left: 5px;
        }
        .container {
            padding: 20px 40px;
        }
        .manage-users-box {
            background-color: #1E293B;
            padding: 20px;
            border-radius: 8px;
        }
        .manage-users-box h2 {
            color: #A855F7;
            margin-bottom: 5px;
        }
        .manage-users-box p {
            margin-bottom: 15px;
            color: #94A3B8;
        }
        .search-bar {
            width: 100%;
            padding: 10px;
            background-color: #334155;
            border: none;
            border-radius: 4px;
            color: white;
            margin-bottom: 20px;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        .action-buttons a {
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            font-weight: bold;
        }
        .action-buttons .dashboard {
            background-color: #22C55E;
        }
        .action-buttons .create-admin {
            background-color: #A855F7;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #1E293B;
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            text-align: left;
            padding: 12px 15px;
            border-bottom: 1px solid #334155;
        }
        th {
            color: #CBD5E1;
        }
        .badge-user {
            background-color: #2563EB;
            padding: 3px 7px;
            border-radius: 4px;
            font-size: 12px;
        }
        .badge-admin {
            background-color: #DC2626;
            padding: 3px 7px;
            border-radius: 4px;
            font-size: 12px;
        }
        .yes-badge {
            background-color: #22C55E;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
        }
        .view-button {
            border: 1px solid #A855F7;
            color: #A855F7;
            padding: 5px 12px;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 8px;
        }
        .delete-button {
            background-color: #DC2626;
            border: none;
            padding: 5px 12px;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Admin Panel</div>
    <div class="links">
        <a href="AdminDashBoard.jsp">Return to Dashboard</a>
        <a href="Statistics.jsp">Statistics</a>
        <a href="Manage.jsp" class="active">Manage Users</a>
        <a href="AdminPanel.jsp">Admin Profile</a>
        <a href="CreateAdmin.jsp">Create Admin</a>
        <a href="#">Johan <span class="user-badge">Admin</span></a>
        <a href="../View/index.jsp">Logout</a>
    </div>
</div>

<div class="container">
    <div class="manage-users-box">
        <h2>Manage Users</h2>
        <p>Manage all users in the system</p>
        
        <input class="search-bar" type="text" placeholder="Search users by name or email...">

        <div class="action-buttons">
            <a href="#" class="dashboard">🏠 Dashboard</a>
            <a href="#" class="create-admin">➕ Create New Admin</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Joined</th>
                    <th>Profile</th>
                    <th>Plans</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Dev Rai</td>
                    <td>raidev3457@gmail.com</td>
                    <td><span class="badge-user">user</span></td>
                    <td>Apr 19, 2025, 06:44 PM</td>
                    <td><span class="yes-badge">Yes</span></td>
                    <td>1</td>
                    <td>
                        <a class="view-button" href="#">View Plans</a>
                        <a class="delete-button" href="#">Delete</a>
                    </td>
                </tr>
                <tr>
                    <td>Johan</td>
                    <td>johanwhite2024@gmail.com</td>
                    <td><span class="badge-admin">admin</span></td>
                    <td>Apr 18, 2025, 03:19 PM</td>
                    <td><span class="yes-badge">Yes</span></td>
                    <td>0</td>
                    <td>
                        <a class="view-button" href="#">View Plans</a>
                    </td>
                </tr>
                <tr>
                    <td>John Smith</td>
                    <td>johnsmith2030sj@gmail.com</td>
                    <td><span class="badge-user">user</span></td>
                    <td>Apr 18, 2025, 03:11 PM</td>
                    <td><span class="yes-badge">Yes</span></td>
                    <td>0</td>
                    <td>
                        <a class="view-button" href="#">View Plans</a>
                        <a class="delete-button" href="#">Delete</a>
                    </td>
                </tr>
                <tr>
                    <td>Himal</td>
                    <td>Himal@gmail.com</td>
                    <td><span class="badge-user">user</span></td>
                    <td>Apr 17, 2025, 02:55 PM</td>
                    <td><span class="yes-badge">Yes</span></td>
                    <td>1</td>
                    <td>
                        <a class="view-button" href="#">View Plans</a>
                        <a class="delete-button" href="#">Delete</a>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
