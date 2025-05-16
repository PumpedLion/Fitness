<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Model.FitnessProfile" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="DAO.FitnessProfileDAO" %>
<%
    String userName = (session != null && session.getAttribute("userName") != null)
                      ? (String) session.getAttribute("userName")
                      : "Guest";
    
    FitnessProfileDAO profileDAO = new FitnessProfileDAO();
    List<FitnessProfile> allProfiles = profileDAO.getAllFitnessProfiles();
    
    // Calculate statistics
    int totalUsers = allProfiles.size();
    double avgAge = 0;
    double avgHeight = 0;
    double avgWeight = 0;
    double avgBMI = 0;
    
    Map<String, Integer> activityLevelCount = new HashMap<>();
    Map<String, Integer> goalCount = new HashMap<>();
    Map<String, Integer> bmiCategoryCount = new HashMap<>();
    
    if (totalUsers > 0) {
        for (FitnessProfile profile : allProfiles) {
            avgAge += profile.getAge();
            avgHeight += profile.getHeight();
            avgWeight += profile.getWeight();
            
            // Calculate BMI
            double heightInMeters = profile.getHeight() / 100.0;
            double bmi = profile.getWeight() / (heightInMeters * heightInMeters);
            avgBMI += bmi;
            
            // Count activity levels
            String activityLevel = profile.getActivityLevel();
            activityLevelCount.put(activityLevel, activityLevelCount.getOrDefault(activityLevel, 0) + 1);
            
            // Count goals
            String[] goals = profile.getGoal().split(",");
            for (String goal : goals) {
                goal = goal.trim();
                goalCount.put(goal, goalCount.getOrDefault(goal, 0) + 1);
            }
            
            // Count BMI categories
            String bmiCategory;
            if (bmi < 18.5) bmiCategory = "Underweight";
            else if (bmi < 25) bmiCategory = "Normal";
            else if (bmi < 30) bmiCategory = "Overweight";
            else bmiCategory = "Obese";
            bmiCategoryCount.put(bmiCategory, bmiCategoryCount.getOrDefault(bmiCategory, 0) + 1);
        }
        
        avgAge /= totalUsers;
        avgHeight /= totalUsers;
        avgWeight /= totalUsers;
        avgBMI /= totalUsers;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fitness Statistics</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            grid-template-columns: repeat(2, 1fr);
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }

        .stat-item {
            background-color: #334155;
            padding: 15px;
            border-radius: 6px;
            text-align: center;
        }

        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #A855F7;
            margin: 10px 0;
        }

        .stat-label {
            color: #94A3B8;
            font-size: 14px;
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin-top: 20px;
        }

        .full-width {
            grid-column: span 2;
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
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Fitness Statistics</div>
    <div class="links">
        <a href="AdminDashBoard.jsp">Return to Dashboard</a>
        <a href="Statistics.jsp" class="active">Statistics</a>
        <a href="Manage.jsp">Manage Users</a>
        <a href="AdminPanel.jsp">Admin Profile</a>
        <a href="CreateAdmin.jsp">Create Admin</a>
        <a href="#"><%= userName %> <span class="user-badge">Admin</span></a>
        <a href="../View/index.jsp">Logout</a>
    </div>
</div>

<div class="container">
    <!-- Overview Statistics -->
    <div class="card full-width">
        <h2>Overview Statistics</h2>
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-value"><%= totalUsers %></div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-item">
                <div class="stat-value"><%= String.format("%.1f", avgAge) %></div>
                <div class="stat-label">Average Age</div>
            </div>
            <div class="stat-item">
                <div class="stat-value"><%= String.format("%.1f", avgHeight) %> cm</div>
                <div class="stat-label">Average Height</div>
            </div>
            <div class="stat-item">
                <div class="stat-value"><%= String.format("%.1f", avgWeight) %> kg</div>
                <div class="stat-label">Average Weight</div>
            </div>
            <div class="stat-item">
                <div class="stat-value"><%= String.format("%.1f", avgBMI) %></div>
                <div class="stat-label">Average BMI</div>
            </div>
        </div>
    </div>

    <!-- BMI Distribution -->
    <div class="card">
        <h2>BMI Distribution</h2>
        <div class="chart-container">
            <canvas id="bmiChart"></canvas>
        </div>
    </div>

    <!-- Activity Level Distribution -->
    <div class="card">
        <h2>Activity Level Distribution</h2>
        <div class="chart-container">
            <canvas id="activityChart"></canvas>
        </div>
    </div>

    <!-- Fitness Goals Distribution -->
    <div class="card full-width">
        <h2>Fitness Goals Distribution</h2>
        <div class="chart-container">
            <canvas id="goalsChart"></canvas>
        </div>
    </div>
</div>

<script>
// BMI Distribution Chart
const bmiCtx = document.getElementById('bmiChart').getContext('2d');
new Chart(bmiCtx, {
    type: 'pie',
    data: {
        labels: <%= Arrays.toString(bmiCategoryCount.keySet().toArray()) %>,
        datasets: [{
            data: <%= Arrays.toString(bmiCategoryCount.values().toArray()) %>,
            backgroundColor: [
                '#FBBF24', // Underweight
                '#4ADE80', // Normal
                '#F87171', // Overweight
                '#EF4444'  // Obese
            ]
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom',
                labels: {
                    color: '#FFFFFF'
                }
            }
        }
    }
});

// Activity Level Chart
const activityCtx = document.getElementById('activityChart').getContext('2d');
new Chart(activityCtx, {
    type: 'doughnut',
    data: {
        labels: <%= Arrays.toString(activityLevelCount.keySet().toArray()) %>,
        datasets: [{
            data: <%= Arrays.toString(activityLevelCount.values().toArray()) %>,
            backgroundColor: [
                '#A855F7',
                '#8B5CF6',
                '#7C3AED',
                '#6D28D9'
            ]
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom',
                labels: {
                    color: '#FFFFFF'
                }
            }
        }
    }
});

// Goals Distribution Chart
const goalsCtx = document.getElementById('goalsChart').getContext('2d');
new Chart(goalsCtx, {
    type: 'bar',
    data: {
        labels: <%= Arrays.toString(goalCount.keySet().toArray()) %>,
        datasets: [{
            label: 'Number of Users',
            data: <%= Arrays.toString(goalCount.values().toArray()) %>,
            backgroundColor: '#A855F7'
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: false
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    color: '#FFFFFF'
                },
                grid: {
                    color: '#334155'
                }
            },
            x: {
                ticks: {
                    color: '#FFFFFF'
                },
                grid: {
                    color: '#334155'
                }
            }
        }
    }
});
</script>

</body>
</html>
