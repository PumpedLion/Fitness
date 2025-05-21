package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import DAO.UserDAO;
import DAO.FitnessProfileDAO;
import DAO.GeneratedPlanDAO;

/**
 * Servlet implementation class UserDeleteServlet
 */
@WebServlet("/UserDeleteServlet")
public class UserDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO;
	private final FitnessProfileDAO profileDAO;
	private final GeneratedPlanDAO planDAO;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserDeleteServlet() {
        super();
        this.userDAO = new UserDAO();
        this.profileDAO = new FitnessProfileDAO();
        this.planDAO = new GeneratedPlanDAO();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
        
        // Check if the current user is an admin
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            response.sendRedirect("View/UserLogin.jsp");
            return;
        }

        try {
            // Get the user ID to delete
            int userId = Integer.parseInt(request.getParameter("userId"));
            
            // Delete user's generated plans first
            planDAO.deleteAllPlansByUserId(userId);
            
            // Delete user's fitness profile
            profileDAO.deleteFitnessProfile(userId);
            
            // Finally, delete the user
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                response.sendRedirect("Admin/Manage.jsp?message=User deleted successfully&type=success");
            } else {
                response.sendRedirect("Admin/Manage.jsp?message=Failed to delete user&type=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Admin/Manage.jsp?message=Error: " + e.getMessage() + "&type=error");
        }
	}

}
