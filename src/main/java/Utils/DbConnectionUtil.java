package Utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnectionUtil {

    // Database URL, user, and password
    private static final String URL = "jdbc:mysql://localhost:3306/fitness_app";
    private static final String USER = "root";  // Update with your database username
    private static final String PASSWORD = "";  // Update with your database password

    // Method to establish a connection to the database
    public static Connection getConnection() {
        Connection conn = null;

        try {
            // Register MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Debug log to check the connection details
            System.out.println("Connecting to database with URL: " + URL);
            System.out.println("Using username: " + USER);

            // Establish the connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            if (conn != null) {
                System.out.println("Database connection successful.");
            }

        } catch (SQLException e) {
            // Print the SQL exception details for debugging
            System.out.println("SQLException: Unable to connect to the database.");
            System.out.println("Error message: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            // Handle if the driver is not found
            System.out.println("ClassNotFoundException: MySQL JDBC Driver not found.");
            e.printStackTrace();
        } catch (Exception e) {
            // Catch any other exception
            System.out.println("Exception: An error occurred while trying to connect.");
            System.out.println("Error message: " + e.getMessage());
            e.printStackTrace();
        }

        return conn;
    }


    // Optional: You can close the connection outside of the method if needed
    public static void closeConnection(Connection conn) {
        try {
            if (conn != null) {
                conn.close();
                System.out.println("Database connection closed.");
            }
        } catch (SQLException e) {
            System.out.println("SQLException: Unable to close the database connection.");
            e.printStackTrace();
        }
    }
}
