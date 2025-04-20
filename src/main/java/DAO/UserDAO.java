package DAO;

import Utils.DbConnectionUtil;
import java.sql.*;

import Model.User;

public class UserDAO {

    // Register New User or Admin
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users(name, email, password, role) VALUES (?, ?, ?, ?)";
        
        // Get the connection
        Connection conn = DbConnectionUtil.getConnection();
        
        // Check if the connection is null
        if (conn == null) {
            System.out.println("[DAO] Error: Unable to establish a connection to the database.");
            return false;
        }
        
        // Proceed only if the connection is established
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getFullName()); // Maps to `name` column
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());

            // Set role as "admin" or "user"
            String role = user.isAdmin() ? "admin" : "user";
            stmt.setString(4, role);

            int result = stmt.executeUpdate();
            System.out.println("[DAO] Insert result: " + result);
            return result > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            System.out.println("[DAO] Error: Email already exists.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("[DAO] SQL Exception: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("[DAO] General Exception: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                // Close the connection if it's open
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

    // Login User or Admin
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        // Get the connection
        Connection conn = DbConnectionUtil.getConnection();

        // Check if the connection is null
        if (conn == null) {
            System.out.println("[DAO] Error: Unable to establish a connection to the database.");
            return null;
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("name")); // maps to 'name' column
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setAdmin("admin".equalsIgnoreCase(rs.getString("role"))); // maps 'role' enum to boolean
                return user;
            }

        } catch (SQLException e) {
            System.out.println("[DAO] SQL Exception during login: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("[DAO] General Exception during login: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                // Close the connection if it's open
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
}
