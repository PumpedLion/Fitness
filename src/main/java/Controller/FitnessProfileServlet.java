package Controller;

import DAO.FitnessProfileDAO;
import Model.FitnessProfile;

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
        boolean isAdmin = session.getAttribute("isAdmin") != null && (boolean) session.getAttribute("isAdmin");

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

            // Check if user already has a profile
            FitnessProfile existingProfile = profileDAO.getFitnessProfileByUserId(userId);
            FitnessProfile profile;

            if (existingProfile != null) {
                // Update existing profile
                profile = existingProfile;
                profile.setAge(age);
                profile.setGender(gender);
                profile.setHeight(height);
                profile.setWeight(weight);
                profile.setGoal(goal);
                profile.setActivityLevel(activityLevel);
                profile.setHealthIssues((healthIssues != null && !healthIssues.trim().isEmpty()) ? healthIssues : null);
                profile.setDietaryRestrictions((dietaryRestrictions != null && !dietaryRestrictions.trim().isEmpty()) ? dietaryRestrictions : null);
                
                boolean success = profileDAO.updateFitnessProfile(profile);
                if (success) {
                    session.setAttribute("fitnessProfile", profile);
                    session.setAttribute("message", "Fitness profile updated successfully!");
                    // Redirect based on user type
                    if (isAdmin) {
                        response.sendRedirect("Admin/AdminDashBoard.jsp");
                    } else {
                        response.sendRedirect("View/UserDashBoard.jsp");
                    }
                } else {
                    session.setAttribute("error", "Failed to update profile. Please try again.");
                    if (isAdmin) {
                        response.sendRedirect("Admin/AdminDashBoard.jsp");
                    } else {
                        response.sendRedirect("View/UserDashBoard.jsp");
                    }
                }
            } else {
                // Create new profile
                profile = new FitnessProfile();
                profile.setUserId(userId);
                profile.setAge(age);
                profile.setGender(gender);
                profile.setHeight(height);
                profile.setWeight(weight);
                profile.setGoal(goal);
                profile.setActivityLevel(activityLevel);
                profile.setHealthIssues((healthIssues != null && !healthIssues.trim().isEmpty()) ? healthIssues : null);
                profile.setDietaryRestrictions((dietaryRestrictions != null && !dietaryRestrictions.trim().isEmpty()) ? dietaryRestrictions : null);

                boolean success = profileDAO.saveFitnessProfile(profile);
                if (success) {
                    session.setAttribute("fitnessProfile", profile);
                    session.setAttribute("message", "Fitness profile saved successfully!");
                    // Redirect based on user type
                    if (isAdmin) {
                        response.sendRedirect("Admin/AdminDashBoard.jsp");
                    } else {
                        response.sendRedirect("View/UserDashBoard.jsp");
                    }
                } else {
                    session.setAttribute("error", "Failed to save profile. Please try again.");
                    response.sendRedirect("View/SaveProfile.jsp");
                }
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Please enter valid numbers for age, height, and weight.");
            if (isAdmin) {
                response.sendRedirect("Admin/AdminDashBoard.jsp");
            } else {
                response.sendRedirect("View/UserDashBoard.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Unexpected error occurred.");
            if (isAdmin) {
                response.sendRedirect("Admin/AdminDashBoard.jsp");
            } else {
                response.sendRedirect("View/UserDashBoard.jsp");
            }
        }
    }
}