package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet implementation class UserLogoutServlet
 */
@WebServlet("/UserLogoutServlet")
public class UserLogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserLogoutServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get the current session
		HttpSession session = request.getSession(false);
		
		if (session != null) {
			// Remove all session attributes
			session.removeAttribute("userId");
			session.removeAttribute("userName");
			session.removeAttribute("userEmail");
			session.removeAttribute("isAdmin");
			session.removeAttribute("fitnessProfile");
			
			// Invalidate the session
			session.invalidate();
		}
		
		// Get the context path and redirect to the login page
		String contextPath = request.getContextPath();
		response.sendRedirect(contextPath + "/View/Index.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
