<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Model.User" %>
<%@ page import="Model.FitnessProfile" %>
<%@ page import="java.util.*" %>
<%@ page import="DAO.UserDAO" %>
<%@ page import="DAO.FitnessProfileDAO" %>
<%
    String userName = (session != null && session.getAttribute("userName") != null)
                      ? (String) session.getAttribute("userName")
                      : "Guest";
    
    UserDAO userDAO = new UserDAO();
    FitnessProfileDAO profileDAO = new FitnessProfileDAO();
    List<User> allUsers = userDAO.getAllUsers();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
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
        }

        .card {
            background-color: #1E293B;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.4);
            margin-bottom: 20px;
        }

        .card h2 {
            color: #A855F7;
            margin-bottom: 20px;
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .users-table th,
        .users-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #334155;
        }

        .users-table th {
            background-color: #334155;
            color: #FFFFFF;
            font-weight: bold;
        }

        .users-table tr:hover {
            background-color: #334155;
        }

        .button-delete {
            background-color: #EF4444;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .button-delete:hover {
            background-color: #DC2626;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-admin {
            background-color: #A855F7;
            color: white;
        }

        .status-user {
            background-color: #22C55E;
            color: white;
        }

        .search-box {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #334155;
            border-radius: 4px;
            background-color: #1E293B;
            color: white;
        }

        .search-box:focus {
            outline: none;
            border-color: #A855F7;
        }

        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
        }

        .message.success {
            background-color: #22C55E;
            color: white;
        }

        .message.error {
            background-color: #EF4444;
            color: white;
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
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Manage Users</div>
    <div class="links">
        <a href="AdminDashBoard.jsp">Return to Dashboard</a>
        <a href="Statistics.jsp">Statistics</a>
        <a href="Manage.jsp" class="active">Manage Users</a>
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
    <div class="card">
        <h2>User Management</h2>
        
        <% if (request.getParameter("message") != null) { %>
            <div class="message <%= request.getParameter("type") %>">
                <%= request.getParameter("message") %>
            </div>
        <% } %>

        <input type="text" id="searchInput" class="search-box" placeholder="Search users by name or email..." onkeyup="searchUsers()">

        <table class="users-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Fitness Profile</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (User user : allUsers) { 
                    FitnessProfile profile = profileDAO.getFitnessProfileByUserId(user.getId());
                %>
                    <tr>
                        <td><%= user.getId() %></td>
                        <td><%= user.getFullName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td>
                            <span class="status-badge <%= user.isAdmin() ? "status-admin" : "status-user" %>">
                                <%= user.isAdmin() ? "Admin" : "User" %>
                            </span>
                        </td>
                        <td>
                            <% if (profile != null) { %>
                                <span class="status-badge status-user">Has Profile</span>
                            <% } else { %>
                                <span class="status-badge status-admin">No Profile</span>
                            <% } %>
                        </td>
                        <td>
                            <form action="../UserDeleteServlet" method="post" style="display: inline;">
                                <input type="hidden" name="userId" value="<%= user.getId() %>">
                                <button type="submit" class="button-delete" onclick="return confirm('Are you sure you want to delete this user and their fitness profile?')">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
function searchUsers() {
    const input = document.getElementById('searchInput');
    const filter = input.value.toLowerCase();
    const table = document.querySelector('.users-table');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const cells = row.getElementsByTagName('td');
        let found = false;

        for (let j = 0; j < cells.length; j++) {
            const cell = cells[j];
            if (cell) {
                const text = cell.textContent || cell.innerText;
                if (text.toLowerCase().indexOf(filter) > -1) {
                    found = true;
                    break;
                }
            }
        }

        row.style.display = found ? '' : 'none';
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
</script>
</body>
</html>
