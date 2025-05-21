package Controller;

import DAO.UserDAO;
import DAO.FitnessProfileDAO;
import DAO.GeneratedPlanDAO;
import Model.User;
import Model.FitnessProfile;
import Model.GeneratedPlan;
import Utils.PasswordUtils;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("AdminLoginServlet doPost called");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("Email or password is empty");
            response.sendRedirect(request.getContextPath() + "/View/Index.jsp?error=empty&type=admin");
            return;
        }

        // Hash input password
        String hashedPassword = PasswordUtils.hashPassword(password);
        System.out.println("Password hashed successfully");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.loginUser(email, hashedPassword);
        System.out.println("User authentication result: " + (user != null ? "SUCCESS" : "FAILED"));

        if (user != null && user.isAdmin()) {
            // Create new session and invalidate any existing session
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("isAdmin", true);

            System.out.println("Admin logged in successfully - ID: " + user.getId() + ", Name: " + user.getFullName());

            // Check if admin has a fitness profile
            FitnessProfileDAO profileDAO = new FitnessProfileDAO();
            FitnessProfile profile = profileDAO.getFitnessProfileByUserId(user.getId());
            System.out.println("Fitness profile loaded: " + (profile != null ? "FOUND" : "NOT FOUND"));

            if (profile != null) {
                // Admin has a profile, set it in session
                session.setAttribute("fitnessProfile", profile);
                
                // Load admin's plans
                GeneratedPlanDAO planDAO = new GeneratedPlanDAO();
                List<GeneratedPlan> plans = planDAO.getPlansByUserId(user.getId());
                System.out.println("Admin plans loaded: " + plans.size() + " plans found");
                session.setAttribute("userPlans", plans);
                
                response.sendRedirect(request.getContextPath() + "/Admin/AdminDashBoard.jsp");
            } else {
                // No profile, redirect to create profile page
                response.sendRedirect(request.getContextPath() + "/View/SaveProfile.jsp");
            }
        } else {
            System.out.println("Login failed - Invalid credentials");
            response.sendRedirect(request.getContextPath() + "/View/Index.jsp?error=invalid&type=admin");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the login page
        response.sendRedirect(request.getContextPath() + "/View/Index.jsp");
    }
}
