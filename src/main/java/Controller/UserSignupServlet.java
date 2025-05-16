package Controller;

import Model.User;
import Model.FitnessProfile;
import DAO.UserDAO;
import DAO.FitnessProfileDAO;
import Utils.PasswordUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UserSignupServlet")
public class UserSignupServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String adminKey = request.getParameter("adminkey");

        final String correctAdminKey = "yourAdminKey";  // Replace with your actual key
        boolean isAdmin = false;

        if (adminKey != null && !adminKey.isEmpty()) {
            if (adminKey.equals(correctAdminKey)) {
                isAdmin = true;
            } else {
                System.out.println("Admin key is wrong for: " + fullname + ", Email: " + email);
                response.sendRedirect("View/Index.jsp?error=adminkey");
                return;
            }
        }

        // Hash the password before storing
        String hashedPassword = PasswordUtils.hashPassword(password);

        User newUser = new User(fullname, email, hashedPassword, isAdmin);
        UserDAO userDAO = new UserDAO();

        boolean isRegistered = userDAO.registerUser(newUser);

        if (isRegistered) {
            System.out.println("User registered successfully: " + fullname + ", Email: " + email);
            
            // Get the registered user to get their ID
            User registeredUser = userDAO.loginUser(email, hashedPassword);
            
            if (registeredUser != null) {
                // Set user session attributes
                HttpSession session = request.getSession();
                session.setAttribute("userId", registeredUser.getId());
                session.setAttribute("userName", registeredUser.getFullName());
                session.setAttribute("userEmail", registeredUser.getEmail());
                session.setAttribute("isAdmin", registeredUser.isAdmin());
                
                // Check if user has a fitness profile
                FitnessProfileDAO profileDAO = new FitnessProfileDAO();
                FitnessProfile profile = profileDAO.getFitnessProfileByUserId(registeredUser.getId());
                
                if (profile != null) {
                    // User has a profile, redirect to dashboard
                    session.setAttribute("fitnessProfile", profile);
                    response.sendRedirect("View/UserDashBoard.jsp");
                } else {
                    // No profile, redirect to create profile page
                    response.sendRedirect("View/SaveProfile.jsp");
                }
            } else {
                response.sendRedirect("View/Index.jsp?error=login");
            }
        } else {
            System.out.println("Error registering user: " + fullname + ", Email: " + email);
            response.sendRedirect("View/Index.jsp?error=1");
        }
    }
}
