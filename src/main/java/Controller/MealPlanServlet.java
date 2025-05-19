package Controller;

import Model.FitnessProfile;
import Model.GeneratedPlan;
import Model.User;
import DAO.FitnessProfileDAO;
import DAO.GeneratedPlanDAO;
import DAO.UserDAO;
import Service.GeminiService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/MealPlanServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class MealPlanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final GeminiService geminiService;
    private final GeneratedPlanDAO planDAO;
    private final UserDAO userDAO;
    private final FitnessProfileDAO profileDAO;

    public MealPlanServlet() {
        System.out.println("MealPlanServlet constructor called");
        try {
            this.geminiService = new GeminiService();
            this.planDAO = new GeneratedPlanDAO();
            this.userDAO = new UserDAO();
            this.profileDAO = new FitnessProfileDAO();
        } catch (Exception e) {
            System.err.println("Error initializing MealPlanServlet: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize MealPlanServlet", e);
        }
    }

    @Override
    public void init() throws ServletException {
        System.out.println("MealPlanServlet initialized");
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("MealPlanServlet doPost called");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        try {
            // Check if user is logged in
            Integer userId = (Integer) session.getAttribute("userId");
            System.out.println("User ID from session: " + userId);
            
            if (userId == null) {
                System.out.println("User not logged in");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\": \"Please login first\"}");
                return;
            }

            String action = request.getParameter("action");
            System.out.println("Action parameter: " + action);
            
            if (action == null) {
                System.out.println("No action parameter provided");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Action parameter is required\"}");
                return;
            }

            switch (action) {
                case "generate":
                    System.out.println("Generating plan...");
                    generatePlan(request, response, userId);
                    break;
                case "delete":
                    System.out.println("Deleting plan...");
                    deleteMealPlan(request, response, userId);
                    break;
                default:
                    System.out.println("Invalid action: " + action);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            System.err.println("Error in doPost: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Internal server error: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("MealPlanServlet doGet called");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        try {
            // Check if user is logged in
            Integer userId = (Integer) session.getAttribute("userId");
            System.out.println("User ID from session: " + userId);
            
            if (userId == null) {
                System.out.println("User not logged in");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\": \"Please login first\"}");
                return;
            }

            // Get all plans for the user
            List<GeneratedPlan> plans = planDAO.getPlansByUserId(userId);
            System.out.println("Retrieved " + plans.size() + " plans for user: " + userId);
            
            // Convert plans to JSON array
            StringBuilder jsonPlans = new StringBuilder("[");
            for (int i = 0; i < plans.size(); i++) {
                if (i > 0) jsonPlans.append(",");
                jsonPlans.append(plans.get(i).toString());
            }
            jsonPlans.append("]");
            
            out.print(jsonPlans.toString());
        } catch (Exception e) {
            System.err.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Failed to retrieve plans: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    private void generatePlan(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {
        System.out.println("generatePlan method called for user: " + userId);
        PrintWriter out = response.getWriter();

        try {
            // Get user's fitness profile
            FitnessProfile profile = profileDAO.getFitnessProfileByUserId(userId);
            System.out.println("Fitness profile retrieved: " + (profile != null));
            
            if (profile == null) {
                System.out.println("No fitness profile found for user: " + userId);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Please complete your fitness profile first\"}");
                return;
            }

            System.out.println("User profile for plan generation: " + profile);

            // Create workout plan prompt
            String workoutPrompt = String.format(
                "Create a personalized 7-day workout plan for a %d-year-old %s, " +
                "weight: %dkg, height: %dcm, " +
                "with activity level: %s. " +
                "Their fitness goals are: %s. " +
                "%s " +
                "Format the plan by day (Day 1, Day 2, etc.), including specific exercises, " +
                "sets, reps, and rest periods. Include warm-up and cool-down routines. " +
                "Provide clear, detailed instructions that would be suitable for their fitness level.",
                profile.getAge(),
                profile.getGender().toLowerCase(),
                profile.getWeight(),
                profile.getHeight(),
                profile.getActivityLevel(),
                profile.getGoal(),
                profile.getHealthIssues() != null ? 
                    "Health issues to consider: " + profile.getHealthIssues() : ""
            );

            // Create meal plan prompt
            String mealPrompt = String.format(
                "Create a 7-day meal plan for a %d-year-old %s, " +
                "weight: %dkg, height: %dcm, " +
                "with activity level: %s. " +
                "Their fitness goals are: %s. " +
                "%s " +
                "The meal plan should include breakfast, lunch, dinner, and snacks for each day. " +
                "Specify portion sizes and approximate calorie counts per meal. " +
                "Focus on whole, nutrient-dense foods that support their fitness goals.",
                profile.getAge(),
                profile.getGender().toLowerCase(),
                profile.getWeight(),
                profile.getHeight(),
                profile.getActivityLevel(),
                profile.getGoal(),
                profile.getDietaryRestrictions() != null ? 
                    "Dietary restrictions: " + profile.getDietaryRestrictions() : ""
            );

            System.out.println("Generating workout plan...");
            String workoutPlan = geminiService.generateWorkoutPlan(workoutPrompt);
            System.out.println("Workout plan generated successfully");

            System.out.println("Generating meal plan...");
            String mealPlan = geminiService.generateMealPlan(mealPrompt);
            System.out.println("Meal plan generated successfully");

            // Save the generated plan
            String title = request.getParameter("title");
            if (title == null || title.trim().isEmpty()) {
                title = "Fitness Plan";
            }
            System.out.println("Plan title: " + title);

            GeneratedPlan plan = new GeneratedPlan(userId, title, workoutPlan, mealPlan);
            boolean success = planDAO.createPlan(plan);
            System.out.println("Plan saved to database: " + success);

            if (success) {
                out.print("{\"message\": \"Plan generated successfully\", \"plan\": " + plan.toString() + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Failed to save plan to database\"}");
            }
        } catch (Exception e) {
            System.err.println("Error generating plan: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Failed to generate plan: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    private void deleteMealPlan(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {
        PrintWriter out = response.getWriter();
        String planIdStr = request.getParameter("planId");

        try {
            if (planIdStr == null || planIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Plan ID is required\"}");
                return;
            }

            int planId = Integer.parseInt(planIdStr);
            
            // Verify plan ownership
            GeneratedPlan plan = planDAO.getPlanById(planId);
            if (plan == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Plan not found\"}");
                return;
            }

            if (plan.getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\": \"Unauthorized\"}");
                return;
            }

            boolean success = planDAO.deletePlan(planId, userId);
            if (success) {
                out.print("{\"message\": \"Plan deleted successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Failed to delete plan\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid plan ID\"}");
        } catch (Exception e) {
            System.err.println("Error deleting plan: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Failed to delete plan: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
} 