<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Fitness Dashboard</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #0b1222;
            color: white;
            font-family: Arial, sans-serif;
        }

        .navbar {
            background-color: #1b2234;
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar a {
            color: #ccc;
            text-decoration: none;
            margin-left: 20px;
        }

        .navbar .logo {
            color: #c171f5;
            font-weight: bold;
            font-size: 18px;
        }

        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 20px;
        }

        .title {
            font-size: 24px;
            font-weight: bold;
            color: #d672ff;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #aaa;
            margin-bottom: 20px;
        }

        .form-box {
            background-color: #1a1a1a;
            padding: 20px;
            border-radius: 5px;
        }

        .form-box h3 {
            margin-bottom: 15px;
            font-size: 18px;
        }

        .row {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }

        .row input, .row select, textarea {
            flex: 1;
            padding: 8px;
            background-color: #2c3550;
            color: white;
            border: none;
            border-radius: 3px;
        }

        .checkbox-group {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 15px;
        }

        .checkbox-group label {
            display: flex;
            align-items: center;
        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 6px;
        }

        textarea {
            width: 100%;
            height: 60px;
        }

        .submit-btn {
            margin-top: 20px;
            width: 100%;
            background-color: #b021f9;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .submit-btn:hover {
            background-color: #9400d3;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">FitnessPro</div>
    <div>
        <a href="#">Dashboard</a>
        <a href="#">Dev Rai</a>
        <a href="#">Logout</a>
    </div>
</div>

<div class="container">
    <div class="title">Your Fitness Dashboard</div>
    <div class="subtitle">Before generating plans, we need to know more about you</div>

    <form action="#" method="post"> <!-- No server action, JavaScript handles redirect -->
        <div class="form-box">
            <h3>Your Fitness Profile</h3>

            <div class="row">
                <input type="number" name="age" placeholder="Age" required>
                <select name="gender" required>
                    <option value="">Select Gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                </select>
            </div>

            <div class="row">
                <input type="number" name="weight" placeholder="Weight (kg)" required>
                <input type="number" name="height" placeholder="Height (cm)" required>
            </div>

            <div class="row">
                <select name="activityLevel" required>
                    <option value="">Select Activity Level</option>
                    <option value="Sedentary">Sedentary (little or no exercise)</option>
                    <option value="Light">Light Exercise (1–3 days/week)</option>
                    <option value="Moderate">Moderate Exercise (3–5 days/week)</option>
                    <option value="Active">Active (6–7 days/week)</option>
                </select>
            </div>

            <div class="checkbox-group">
                <label><input type="checkbox" name="goals" value="Weight Loss">Weight Loss</label>
                <label><input type="checkbox" name="goals" value="Improved Fitness">Improved Fitness</label>
                <label><input type="checkbox" name="goals" value="Improved Flexibility">Improved Flexibility</label>
                <label><input type="checkbox" name="goals" value="Overall Health">Overall Health</label>
                <label><input type="checkbox" name="goals" value="Muscle Gain">Muscle Gain</label>
                <label><input type="checkbox" name="goals" value="Increased Strength">Increased Strength</label>
                <label><input type="checkbox" name="goals" value="Better Endurance">Better Endurance</label>
            </div>

            <textarea name="healthIssues" placeholder="Health Issues or Limitations (optional)"></textarea>
            <br><br>
            <textarea name="dietaryRestrictions" placeholder="Dietary Restrictions (optional)"></textarea>

            <button type="submit" class="submit-btn">Save Profile</button>
        </div>
    </form>
</div>

<script>
    // Intercept form submission and redirect to UserDashBoard.jsp
    document.querySelector("form").addEventListener("submit", function(e) {
        e.preventDefault();  // Stop normal form submission
        // Optional: show a simple confirmation before redirect
        alert("Profile saved successfully!");
        window.location.href = "UserDashBoard.jsp";  // Redirect to your dashboard
    });
</script>

</body>
</html>
