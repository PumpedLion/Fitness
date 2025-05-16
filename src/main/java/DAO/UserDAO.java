package DAO;

import Utils.DbConnectionUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.User;

public class UserDAO {

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users(name, email, password, role) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnectionUtil.getConnection();

            if (conn == null) {
                System.out.println("[DAO] Error: Unable to establish a connection to the database.");
                return false;
            }

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());

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
            // ✅ Close resources to prevent memory leaks
            try {
                if (stmt != null && !stmt.isClosed()) {
                    stmt.close();
                }
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("[DAO] Error closing resources: " + e.getMessage());
                e.printStackTrace();
            }
        }

        return false;
    }

    // Login User or Admin
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        Connection conn = DbConnectionUtil.getConnection();

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
                user.setFullName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setAdmin("admin".equalsIgnoreCase(rs.getString("role")));
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

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        Connection conn = DbConnectionUtil.getConnection();
        
        if (conn == null) {
            System.out.println("[DAO] Error: Unable to establish a connection to the database.");
            return false;
        }
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            int result = stmt.executeUpdate();
            System.out.println("[DAO] Deleted user, result: " + result);
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("[DAO] SQL Exception during user deletion: " + e.getMessage());
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

    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users";
        List<User> users = new ArrayList<>();
        
        Connection conn = DbConnectionUtil.getConnection();
        
        if (conn == null) {
            System.out.println("[DAO] Error: Unable to establish a connection to the database.");
            return users;
        }
        
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setAdmin("admin".equalsIgnoreCase(rs.getString("role")));
                
                users.add(user);
            }
            
            System.out.println("[DAO] Retrieved " + users.size() + " users");
            
        } catch (SQLException e) {
            System.out.println("[DAO] SQL Exception during user retrieval: " + e.getMessage());
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
        
        return users;
    }
}