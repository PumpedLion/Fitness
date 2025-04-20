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
      <span>Dev Rai</span>
      <a href="#">Logout</a>
    </div>
  </div>

  <div class="container">
    <h1>Your Fitness Dashboard</h1>

    <div class="dashboard-grid">
      
      <!-- Left Profile Card -->
      <div class="card">
        <h2>Your Fitness Profile</h2>
        <p class="subtitle">Your personal information used to generate plans</p>

        <div class="info-group">
          <span class="label">Age</span>
          <span class="value">30 years</span>
        </div>

        <div class="info-group">
          <span class="label">Gender</span>
          <span class="value">Male</span>
        </div>

        <div class="info-group">
          <span class="label">Height</span>
          <span class="value">170 cm</span>
        </div>

        <div class="info-group">
          <span class="label">Weight</span>
          <span class="value">70 kg</span>
        </div>

        <div class="info-group">
          <span class="label">Activity Level</span>
          <span class="value">Moderate</span>
        </div>

        <div class="info-group">
          <span class="label">Fitness Goals</span>
          <span class="value">Weight Loss</span>
        </div>

        <button class="btn" onclick="toggleEditForm()">Edit Profile</button>

        <!-- Edit Profile Form (Hidden by Default) -->
        <div class="edit-profile-form" id="editForm">
          <form>
            <div class="form-group">
              <label>Age</label>
              <input type="number" value="30">
            </div>

            <div class="form-group">
              <label>Gender</label>
              <select>
                <option selected>Male</option>
                <option>Female</option>
              </select>
            </div>

            <div class="form-group">
              <label>Height (cm)</label>
              <input type="number" value="170">
            </div>

            <div class="form-group">
              <label>Weight (kg)</label>
              <input type="number" value="70">
            </div>

            <div class="form-group">
              <label>Activity Level</label>
              <select>
                <option>Sedentary</option>
                <option>Light Activity</option>
                <option selected>Moderate</option>
                <option>Very Active</option>
              </select>
            </div>

            <div class="form-group">
              <label>Fitness Goal</label>
              <input type="text" value="Weight Loss">
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

</body>
</html>
