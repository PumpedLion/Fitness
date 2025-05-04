package Controller;

import DAO.FitnessProfileDAO;
import Model.FitnessProfile;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/FitnessProfileServlet")
public class FitnessProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private FitnessProfileDAO profileDAO;

    @Override
    public void init() throws ServletException {
        profileDAO = new FitnessProfileDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String heightStr = request.getParameter("height");
        String weightStr = request.getParameter("weight");
        String goal = request.getParameter("goal");
        String activityLevel = request.getParameter("activity_level");
        String healthIssues = request.getParameter("health_issues");
        String dietaryRestrictions = request.getParameter("dietary_restrictions");

        try {
            int age = Integer.parseInt(ageStr);
            int height = Integer.parseInt(heightStr);
            int weight = Integer.parseInt(weightStr);

            FitnessProfile profile = new FitnessProfile();
            profile.setUserId(userId);
            profile.setAge(age);
            profile.setGender(gender);
            profile.setHeight(height);
            profile.setWeight(weight);
            profile.setGoal(goal);
            profile.setActivityLevel(activityLevel);

            // Handle optional fields
            profile.setHealthIssues((healthIssues != null && !healthIssues.trim().isEmpty()) ? healthIssues : null);
            profile.setDietaryRestrictions((dietaryRestrictions != null && !dietaryRestrictions.trim().isEmpty()) ? dietaryRestrictions : null);

            boolean success = profileDAO.saveFitnessProfile(profile);

            if (success) {
                request.setAttribute("message", "Fitness profile saved successfully!");
                
             // Set profile in request so it can be displayed in JSP
                request.setAttribute("profile", profile);
                
                RequestDispatcher rd = request.getRequestDispatcher("View/UserDashBoard.jsp");
                rd.forward(request, response);
            } else {
                request.setAttribute("error", "Failed to save profile. Please try again.");
                RequestDispatcher rd = request.getRequestDispatcher("View/SaveProfile.jsp");
                rd.forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter valid numbers for age, height, and weight.");
            RequestDispatcher rd = request.getRequestDispatcher("View/SaveProfile.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unexpected error occurred.");
            RequestDispatcher rd = request.getRequestDispatcher("View/SaveProfile.jsp");
            rd.forward(request, response);
        }
    }
}
