package Model;

import java.sql.Timestamp;

public class GeneratedPlan {
    private int id;
    private int userId;
    private String title;
    private String workoutPlan;
    private String mealPlan;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public GeneratedPlan() {}

    public GeneratedPlan(int userId, String title, String workoutPlan, String mealPlan) {
        this.userId = userId;
        this.title = title;
        this.workoutPlan = workoutPlan;
        this.mealPlan = mealPlan;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getWorkoutPlan() { return workoutPlan; }
    public void setWorkoutPlan(String workoutPlan) { this.workoutPlan = workoutPlan; }

    public String getMealPlan() { return mealPlan; }
    public void setMealPlan(String mealPlan) { this.mealPlan = mealPlan; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return String.format(
            "{\"id\": %d, \"userId\": %d, \"title\": \"%s\", \"workoutPlan\": \"%s\", \"mealPlan\": \"%s\", \"createdAt\": \"%s\", \"updatedAt\": \"%s\"}",
            id, userId, title, workoutPlan, mealPlan, createdAt, updatedAt
        );
    }
} 