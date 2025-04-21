package Controller;

import Model.User;
import DAO.UserDAO;
import Utils.PasswordUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
            response.sendRedirect("View/Index.jsp");
        } else {
            System.out.println("Error registering user: " + fullname + ", Email: " + email);
            response.sendRedirect("View/Index.jsp?error=1");
        }
    }
}
