<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Admin User</title>
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
            display: flex;
            justify-content: center;
        }

        .form-card {
            background-color: #1E293B;
            padding: 30px;
            border-radius: 10px;
            width: 600px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.4);
        }

        .form-card h2 {
            color: #A855F7;
            margin-bottom: 5px;
        }

        .form-card p {
            color: #94A3B8;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }

        .form-group input,
        .form-group select {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 6px;
            background-color: #334155;
            color: white;
        }

        .section-title {
            margin-top: 20px;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .permissions {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 10px;
        }

        .permissions label {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        .button-purple {
            background-color: #A855F7;
            color: white;
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .button-cancel {
            background-color: #334155;
            color: white;
            padding: 10px 16px;
            border: 1px solid #64748B;
            border-radius: 6px;
            cursor: pointer;
        }

        input[type="radio"],
        input[type="checkbox"] {
            accent-color: #A855F7;
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
        <a href="AdminPanel.jsp">Admin Profile</a>
        <a href="CreateAdmin.jsp" class="active">Create Admin</a>
        <a href="#">Johan <span class="user-badge">Admin</span></a>
        <a href="../View/index.jsp">Logout</a>
    </div>
</div>

<div class="container">
    <div class="form-card">
        <h2>Create Admin User</h2>
        <p>Create a new administrator account</p>

        <form action="CreateAdminServlet" method="post">
            <div class="form-group">
                <input type="text" name="name" placeholder="Name" required />
                <input type="email" name="email" placeholder="Email" required />
            </div>

            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required />
                <input type="password" name="confirmPassword" placeholder="Confirm Password" required />
            </div>

            <div class="form-group">
                <input type="text" name="adminCode" placeholder="Admin Secret Code" required />
                <select name="department">
                    <option value="General">General</option>
                    <option value="IT">IT</option>
                    <option value="HR">HR</option>
                </select>
            </div>

            <div class="section-title">Access Level</div>
            <div class="permissions">
                <label><input type="radio" name="accessLevel" value="standard" checked /> Standard</label>
                <label><input type="radio" name="accessLevel" value="super" /> Super</label>
            </div>

            <div class="section-title">Permissions</div>
            <div class="permissions">
                <label><input type="checkbox" name="permissions" value="view" checked /> View</label>
                <label><input type="checkbox" name="permissions" value="edit" checked /> Edit</label>
                <label><input type="checkbox" name="permissions" value="delete" /> Delete</label>
                <label><input type="checkbox" name="permissions" value="create" /> Create</label>
                <label><input type="checkbox" name="permissions" value="manageUsers" /> Manage Users</label>
                <label><input type="checkbox" name="permissions" value="manageAdmins" /> Manage Admins</label>
                <label><input type="checkbox" name="permissions" value="analytics" /> View Analytics</label>
            </div>

            <div class="form-actions">
                <button type="button" class="button-cancel">Cancel</button>
                <button type="submit" class="button-purple">Create Admin User</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
