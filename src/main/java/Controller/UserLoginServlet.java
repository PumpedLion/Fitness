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

@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("UserLoginServlet doPost called");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("Email or password is empty");
            request.setAttribute("errorMessage", "Email and password are required.");
            RequestDispatcher rd = request.getRequestDispatcher("View/Index.jsp");
            rd.forward(request, response);
            return;
        }

        // Hash password
        String hashedPassword = PasswordUtils.hashPassword(password);
        System.out.println("Password hashed successfully");

        // Authenticate user
        UserDAO userDAO = new UserDAO();
        User user = userDAO.loginUser(email, hashedPassword);
        System.out.println("User authentication result: " + (user != null ? "SUCCESS" : "FAILED"));

        if (user != null) {
            // Create new session and invalidate any existing session
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("isAdmin", user.isAdmin());

            System.out.println("User logged in successfully - ID: " + user.getId() + ", Name: " + user.getFullName());

            // Load fitness profile
            FitnessProfileDAO profileDAO = new FitnessProfileDAO();
            FitnessProfile profile = profileDAO.getFitnessProfileByUserId(user.getId());
            System.out.println("Fitness profile loaded: " + (profile != null ? "FOUND" : "NOT FOUND"));
            session.setAttribute("fitnessProfile", profile);

            // Load user's plans
            GeneratedPlanDAO planDAO = new GeneratedPlanDAO();
            List<GeneratedPlan> plans = planDAO.getPlansByUserId(user.getId());
            System.out.println("User plans loaded: " + plans.size() + " plans found");
            session.setAttribute("userPlans", plans);

            // Redirect based on role and profile existence
            if (user.isAdmin()) {
                System.out.println("Redirecting to admin dashboard");
                response.sendRedirect(request.getContextPath() + "/Admin/AdminDashBoard.jsp");
            } else {
                if (profile != null) {
                    System.out.println("Redirecting to user dashboard");
                    response.sendRedirect(request.getContextPath() + "/View/UserDashBoard.jsp");
                } else {
                    System.out.println("Redirecting to profile creation page");
                    response.sendRedirect(request.getContextPath() + "/View/SaveProfile.jsp");
                }
            }
        } else {
            System.out.println("Login failed - Invalid credentials");
            request.setAttribute("errorMessage", "Invalid email or password.");
            RequestDispatcher rd = request.getRequestDispatcher("View/Index.jsp");
            rd.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the login page
        response.sendRedirect(request.getContextPath() + "/View/Index.jsp");
    }
}
