<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo">FitnessPro</div>
        <div class="links">
            <a href="AdminPanel.jsp">Admin Panel</a>
            <a href="#">Johan <span style="background:#A855F7; color:white; padding:2px 5px; border-radius:4px; font-size:12px;">Admin</span></a>
            <a href="../View/index.jsp">Logout</a>
        </div>
    </div>

    <div class="container">
        <h1>Your Fitness Dashboard</h1>
        <div class="dashboard">
            <div class="card">
                <h2>Your Fitness Profile</h2>
                <p><strong>Age:</strong> 30 years</p>
                <p><strong>Gender:</strong> Male</p>
                <p><strong>Height:</strong> 170 cm</p>
                <p><strong>Weight:</strong> 70 kg</p>
                <p><strong>Activity Level:</strong> Moderate</p>
                <p><strong>Fitness Goals:</strong> Weight Loss, Improved Fitness, Improved Flexibility</p>
                <button class="btn">Edit Profile</button>
            </div>

            <div class="card">
                <h2>Generate New Plan</h2>
                <p>Create a personalized fitness and meal plan based on your profile</p>
                <input type="text" class="inputField" placeholder="Enter a title for your plan (optional)">
                <button class="btn">Generate New Plan</button>
            </div>
        </div>
    </div>

</body>
</html>
