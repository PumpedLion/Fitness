package Controller;


import Model.User;

import DAO.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


/**
 * Servlet implementation class AdminLoginServlet
 */
@WebServlet("/UserSignupServlet")
public class UserSignupServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form parameters
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String adminKey = request.getParameter("adminkey");

        // Check if adminKey is provided to determine if the user should be an admin
        boolean isAdmin = (adminKey != null && adminKey.equals("yourAdminKey")); // Replace with your actual admin key logic

        // Create a new User object
        User newUser = new User(fullname, email, password, isAdmin);

        // Create a UserDAO instance to interact with the database
        UserDAO userDAO = new UserDAO();

        // Register the new user
        boolean isRegistered = userDAO.registerUser(newUser);

        // Check if registration was successful
        if (isRegistered) {
            System.out.println("User registered successfully: " + fullname + ", Email: " + email);
            response.sendRedirect("index.jsp?success=1"); // Redirect to a success page
        } else {
            System.out.println("Error registering user: " + fullname + ", Email: " + email);
            response.sendRedirect("signup.jsp?error=1"); // Redirect to an error page
        }
    }
}