package DAO;

import Utils.DbConnectionUtil;
import Model.FitnessProfile;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FitnessProfileDAO {

    public boolean saveFitnessProfile(FitnessProfile profile) {
        String sql = "INSERT INTO fitness_profiles (user_id, age, gender, height, weight, goal, activity_level, health_issues, dietary_restrictions, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        Connection conn = DbConnectionUtil.getConnection();

        if (conn == null) {
            System.out.println("[DAO] Error: Unable to establish a connection to the database.");
            return false;
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, profile.getUserId());
            stmt.setInt(2, profile.getAge());
            stmt.setString(3, profile.getGender());
            stmt.setInt(4, profile.getHeight());
            stmt.setInt(5, profile.getWeight());
            stmt.setString(6, profile.getGoal());
            stmt.setString(7, profile.getActivityLevel());

            if (profile.getHealthIssues() != null) {
                stmt.setString(8, profile.getHealthIssues());
            } else {
                stmt.setNull(8, Types.VARCHAR);
            }

            if (profile.getDietaryRestrictions() != null) {
                stmt.setString(9, profile.getDietaryRestrictions());
            } else {
                stmt.setNull(9, Types.VARCHAR);
            }

            int result = stmt.executeUpdate();
            System.out.println("[DAO] Inserted fitness profile, result: " + result);
            return result > 0;

        } catch (SQLException e) {
            System.out.println("[DAO] SQL Exception during fitness profile save: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("[DAO] General Exception: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("[DAO] Error closing the connection: " + e.getMessage());
                e.printStackTrace();
            }
        }

        return false;
    }

    public boolean updateFitnessProfile(FitnessProfile profile) {
        String sql = "UPDATE fitness_profiles SET age = ?, gender = ?, height = ?, weight = ?, " +
                    "goal = ?, activity_level = ?, health_issues = ?, dietary_restrictions = ?, " +
                    "updated_at = NOW() WHERE id = ?";

        Connection conn = DbConnectionUtil.getConnection();

        if (conn == null) {
            System.out.println("[DAO] Error: Unable to establish a connection to the database.");
            return false;
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, profile.getAge());
            stmt.setString(2, profile.getGender());
            stmt.setInt(3, profile.getHeight());
            stmt.setInt(4, profile.getWeight());
            stmt.setString(5, profile.getGoal());
            stmt.setString(6, profile.getActivityLevel());

            if (profile.getHealthIssues() != null) {
                stmt.setString(7, profile.getHealthIssues());
            } else {
                stmt.setNull(7, Types.VARCHAR);
            }

            if (profile.getDietaryRestrictions() != null) {
                stmt.setString(8, profile.getDietaryRestrictions());
            } else {
                stmt.setNull(8, Types.VARCHAR);
            }

            stmt.setInt(9, profile.getId());

            int result = stmt.executeUpdate();
            System.out.println("[DAO] Updated fitness profile, result: " + result);
            return result > 0;

        } catch (SQLException e) {
            System.out.println("[DAO] SQL Exception during fitness profile update: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("[DAO] General Exception: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("[DAO] Error closing the connection: " + e.getMessage());
                e.printStackTrace();
            }
        }

        return false;
    }

    public FitnessProfile getFitnessProfileByUserId(int userId) {
        String sql = "SELECT * FROM fitness_profiles WHERE user_id = ?";

        Connection conn = DbConnectionUtil.getConnection();

        if (conn == null) {
            System.out.println("[DAO] Error: Unable to establish a connection to the database.");
            return null;
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                System.out.println("[DAO] Profile found for user_id: " + userId);

                FitnessProfile profile = new FitnessProfile();
                profile.setId(rs.getInt("id"));
                profile.setUserId(rs.getInt("user_id"));
                profile.setAge(rs.getInt("age"));
                profile.setGender(rs.getString("gender"));
                profile.setHeight(rs.getInt("height"));
                profile.setWeight(rs.getInt("weight"));
                profile.setGoal(rs.getString("goal"));
                profile.setActivityLevel(rs.getString("activity_level"));
                profile.setHealthIssues(rs.getString("health_issues"));
                profile.setDietaryRestrictions(rs.getString("dietary_restrictions"));
                profile.setCreatedAt(rs.getTimestamp("created_at"));
                profile.setUpdatedAt(rs.getTimestamp("updated_at"));

                return profile;
            } else {
                System.out.println("[DAO] No fitness profile found for user_id: " + userId);
            }

        } catch (SQLException e) {
            System.out.println("[DAO] SQL Exception during profile retrieval: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("[DAO] General Exception: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("[DAO] Error closing the connection: " + e.getMessage());
                e.printStackTrace();
            }
        }

        return null;
    }

    public List<FitnessProfile> getAllFitnessProfiles() {
        String sql = "SELECT * FROM fitness_profiles";
        List<FitnessProfile> profiles = new ArrayList<>();
        
        Connection conn = DbConnectionUtil.getConnection();
        
        if (conn == null) {
            System.out.println("[DAO] Error: Unable to establish a connection to the database.");
            return profiles;
        }
        
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                FitnessProfile profile = new FitnessProfile();
                profile.setId(rs.getInt("id"));
                profile.setUserId(rs.getInt("user_id"));
                profile.setAge(rs.getInt("age"));
                profile.setGender(rs.getString("gender"));
                profile.setHeight(rs.getInt("height"));
                profile.setWeight(rs.getInt("weight"));
                profile.setGoal(rs.getString("goal"));
                profile.setActivityLevel(rs.getString("activity_level"));
                profile.setHealthIssues(rs.getString("health_issues"));
                profile.setDietaryRestrictions(rs.getString("dietary_restrictions"));
                profile.setCreatedAt(rs.getTimestamp("created_at"));
                profile.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                profiles.add(profile);
            }
            
            System.out.println("[DAO] Retrieved " + profiles.size() + " fitness profiles");
            
        } catch (SQLException e) {
            System.out.println("[DAO] SQL Exception during profile retrieval: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("[DAO] General Exception: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("[DAO] Error closing the connection: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return profiles;
    }

    public boolean deleteFitnessProfile(int profileId) {
        String sql = "DELETE FROM fitness_profiles WHERE id = ?";
        
        Connection conn = DbConnectionUtil.getConnection();
        
        if (conn == null) {
            System.out.println("[DAO] Error: Unable to establish a connection to the database.");
            return false;
        }
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, profileId);
            
            int result = stmt.executeUpdate();
            System.out.println("[DAO] Deleted fitness profile, result: " + result);
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("[DAO] SQL Exception during fitness profile deletion: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("[DAO] General Exception: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("[DAO] Error closing the connection: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return false;
    }
}
