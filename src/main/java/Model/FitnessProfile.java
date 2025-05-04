package Model;

import java.sql.Timestamp;

public class FitnessProfile {
    private int id;
    private int userId;
    private int age;
    private String gender;
    private int height; // in cm
    private int weight; // in kg
    private String goal; // comma-separated string if multiple goals
    private String activityLevel;
    private String healthIssues;
    private String dietaryRestrictions;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public FitnessProfile() {}

    public FitnessProfile(int userId, int age, String gender, int height, int weight, String goal, String activityLevel, String healthIssues, String dietaryRestrictions) {
        this.userId = userId;
        this.age = age;
        this.gender = gender;
        this.height = height;
        this.weight = weight;
        this.goal = goal;
        this.activityLevel = activityLevel;
        this.healthIssues = healthIssues;
        this.dietaryRestrictions = dietaryRestrictions;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public int getHeight() { return height; }
    public void setHeight(int height) { this.height = height; }

    public int getWeight() { return weight; }
    public void setWeight(int weight) { this.weight = weight; }

    public String getGoal() { return goal; }
    public void setGoal(String goal) { this.goal = goal; }

    public String getActivityLevel() { return activityLevel; }
    public void setActivityLevel(String activityLevel) { this.activityLevel = activityLevel; }

    public String getHealthIssues() { return healthIssues; }
    public void setHealthIssues(String healthIssues) { this.healthIssues = healthIssues; }

    public String getDietaryRestrictions() { return dietaryRestrictions; }
    public void setDietaryRestrictions(String dietaryRestrictions) { this.dietaryRestrictions = dietaryRestrictions; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
