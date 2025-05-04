package Controller;

import DAO.UserDAO;
import DAO.FitnessProfileDAO;
import Model.User;
import Model.FitnessProfile;
import Utils.PasswordUtils;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Hash password
        String hashedPassword = PasswordUtils.hashPassword(password);

        // Authenticate user
        UserDAO userDAO = new UserDAO();
        User user = userDAO.loginUser(email, hashedPassword);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("isAdmin", user.isAdmin());

            System.out.println("[DEBUG] Logged in user ID: " + user.getId());

            // Load fitness profile
            FitnessProfileDAO profileDAO = new FitnessProfileDAO();
            FitnessProfile profile = profileDAO.getFitnessProfileByUserId(user.getId());
            System.out.println("[DEBUG] Fetched fitness profile: " + (profile != null ? "FOUND" : "NOT FOUND"));
            session.setAttribute("fitnessProfile", profile);

            // Redirect based on role and profile existence
            if (user.isAdmin()) {
                response.sendRedirect("Admin/AdminDashBoard.jsp");
            } else {
                if (profile != null) {
                	request.getRequestDispatcher("View/UserDashBoard.jsp").forward(request, response);

                } else {
                    response.sendRedirect("View/SaveProfile.jsp");
                }
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password.");
            RequestDispatcher rd = request.getRequestDispatcher("View/Index.jsp");
            rd.forward(request, response);
        }
    }
}
