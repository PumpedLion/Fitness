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
import java.util.Date;

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
                    generatePlan(request, response);
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

    private void generatePlan(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            // Get user ID from session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            System.out.println("Generating plan for user ID: " + userId);

            if (userId == null) {
                throw new Exception("User not logged in");
            }

            // Get user's fitness profile
            FitnessProfile profile = profileDAO.getFitnessProfileByUserId(userId);
            System.out.println("Retrieved fitness profile for user ID: " + userId);

            if (profile == null) {
                throw new Exception("Fitness profile not found");
            }

            // Create a combined prompt for both workout and meal plans
            String prompt = String.format(
                "Create a comprehensive 7-day fitness plan for a %d-year-old %s, weight: %dkg, height: %dcm, with activity level: %s. Their fitness goals are: %s. %s%s\n\n" +
                "Please provide the plan in exactly this format:\n\n" +
                "## 1. WORKOUT PLAN\n" +
                "[Your workout plan here]\n\n" +
                "## 2. MEAL PLAN\n" +
                "[Your meal plan here]\n\n" +
                "For the workout plan, include specific exercises, sets, reps, and rest periods for each day. Include warm-up and cool-down routines.\n" +
                "For the meal plan, include breakfast, lunch, dinner, and snacks for each day, with portion sizes and approximate calorie counts.\n" +
                "Format each section clearly with day-by-day breakdowns.",
                profile.getAge(),
                profile.getGender(),
                profile.getWeight(),
                profile.getHeight(),
                profile.getActivityLevel(),
                profile.getGoal(),
                profile.getHealthIssues() != null ? "Health issues to consider: " + profile.getHealthIssues() + "\n" : "",
                profile.getDietaryRestrictions() != null ? "Dietary restrictions: " + profile.getDietaryRestrictions() + "\n" : ""
            );

            System.out.println("Generated prompt: " + prompt);

            // Generate the combined plan
            String combinedPlan = geminiService.generateWorkoutPlan(prompt);
            System.out.println("Combined plan generated successfully");
            System.out.println("Plan length: " + combinedPlan.length());
            System.out.println("First 200 characters of plan: " + combinedPlan.substring(0, Math.min(200, combinedPlan.length())));

            // Split the plan into workout and meal sections
            String[] sections = combinedPlan.split("##\\s*2\\.\\s*MEAL\\s*PLAN");
            if (sections.length != 2) {
                // Try alternative splitting if the first attempt fails
                sections = combinedPlan.split("##\\s*MEAL\\s*PLAN");
                if (sections.length != 2) {
                    System.out.println("Failed to split plan into sections. Number of sections: " + sections.length);
                    System.out.println("Plan content: " + combinedPlan);
                    throw new Exception("Failed to parse the generated plan into workout and meal sections");
                }
            }

            // Extract workout plan (remove the first section header)
            String workoutPlan = sections[0].replaceAll("##\\s*1\\.\\s*WORKOUT\\s*PLAN", "").trim();
            workoutPlan = workoutPlan.replaceAll("##\\s*WORKOUT\\s*PLAN", "").trim();
            
            // Add back the meal plan header
            String mealPlan = "## 2. MEAL PLAN" + sections[1].trim();

            System.out.println("Workout plan length: " + workoutPlan.length());
            System.out.println("Meal plan length: " + mealPlan.length());

            // Save the generated plans
            String title = request.getParameter("title");
            if (title == null || title.trim().isEmpty()) {
                title = "Fitness Plan";
            }
            System.out.println("Plan title: " + title);

            GeneratedPlan plan = new GeneratedPlan(userId, title, workoutPlan, mealPlan);
            boolean success = planDAO.createPlan(plan);
            System.out.println("Plan saved to database: " + success);

            if (success) {
                response.setContentType("application/json");
                // Get all plans for the user to return in response
                List<GeneratedPlan> allPlans = planDAO.getPlansByUserId(userId);
                StringBuilder jsonPlans = new StringBuilder("[");
                for (int i = 0; i < allPlans.size(); i++) {
                    if (i > 0) jsonPlans.append(",");
                    GeneratedPlan p = allPlans.get(i);
                    jsonPlans.append(String.format(
                        "{\"id\":%d,\"userId\":%d,\"title\":\"%s\",\"workoutPlan\":\"%s\",\"mealPlan\":\"%s\",\"createdAt\":\"%s\"}",
                        p.getId(),
                        p.getUserId(),
                        escapeJsonString(p.getTitle()),
                        escapeJsonString(p.getWorkoutPlan()),
                        escapeJsonString(p.getMealPlan()),
                        p.getCreatedAt()
                    ));
                }
                jsonPlans.append("]");
                
                // Create a JSON response with status and plans
                String jsonResponse = String.format(
                    "{\"status\":\"success\",\"message\":\"Plan generated successfully\",\"plans\":%s}",
                    jsonPlans.toString()
                );
                response.getWriter().write(jsonResponse);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to save plan to database\"}");
            }
        } catch (Exception e) {
            System.out.println("Error generating plan: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + escapeJsonString(e.getMessage()) + "\"}");
        }
    }

    private String escapeJsonString(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("/", "\\/");
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