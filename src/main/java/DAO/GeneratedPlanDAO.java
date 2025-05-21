package DAO;

import Model.GeneratedPlan;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Utils.DbConnectionUtil;

public class GeneratedPlanDAO {
    private Connection connection;

    public GeneratedPlanDAO() {
        try {
            connection = DbConnectionUtil.getConnection();
            System.out.println("Database connection established successfully");
        } catch (Exception e) {
            System.err.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean createPlan(GeneratedPlan plan) {
        String query = "INSERT INTO generated_plans (user_id, title, workout_plan, meal_plan, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, plan.getUserId());
            stmt.setString(2, plan.getTitle());
            stmt.setString(3, plan.getWorkoutPlan());
            stmt.setString(4, plan.getMealPlan());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<GeneratedPlan> getPlansByUserId(int userId) {
        List<GeneratedPlan> plans = new ArrayList<>();
        String query = "SELECT * FROM generated_plans WHERE user_id = ? ORDER BY created_at DESC";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                GeneratedPlan plan = new GeneratedPlan();
                plan.setId(rs.getInt("id"));
                plan.setUserId(rs.getInt("user_id"));
                plan.setTitle(rs.getString("title"));
                plan.setWorkoutPlan(rs.getString("workout_plan"));
                plan.setMealPlan(rs.getString("meal_plan"));
                plan.setCreatedAt(rs.getTimestamp("created_at"));
                plan.setUpdatedAt(rs.getTimestamp("updated_at"));
                plans.add(plan);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return plans;
    }

    public boolean deletePlan(int planId, int userId) {
        String query = "DELETE FROM generated_plans WHERE id = ? AND user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, planId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public GeneratedPlan getPlanById(int planId) {
        String query = "SELECT * FROM generated_plans WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, planId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                GeneratedPlan plan = new GeneratedPlan();
                plan.setId(rs.getInt("id"));
                plan.setUserId(rs.getInt("user_id"));
                plan.setTitle(rs.getString("title"));
                plan.setWorkoutPlan(rs.getString("workout_plan"));
                plan.setMealPlan(rs.getString("meal_plan"));
                plan.setCreatedAt(rs.getTimestamp("created_at"));
                plan.setUpdatedAt(rs.getTimestamp("updated_at"));
                return plan;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteAllPlansByUserId(int userId) {
        String query = "DELETE FROM generated_plans WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
} 