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

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Hash input password
        String hashedPassword = PasswordUtils.hashPassword(password);

        UserDAO userDAO = new UserDAO();
        User user = userDAO.loginUser(email, hashedPassword);

        if (user != null && user.isAdmin()) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("isAdmin", true);

            // Check if admin has a fitness profile
            FitnessProfileDAO profileDAO = new FitnessProfileDAO();
            FitnessProfile profile = profileDAO.getFitnessProfileByUserId(user.getId());

            if (profile != null) {
                // Admin has a profile, set it in session and redirect to dashboard
                session.setAttribute("fitnessProfile", profile);
                response.sendRedirect("Admin/AdminDashBoard.jsp");
            } else {
                // No profile, redirect to create profile page
                response.sendRedirect("View/SaveProfile.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Wrong Email or Password.");
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
        }
    }
}
