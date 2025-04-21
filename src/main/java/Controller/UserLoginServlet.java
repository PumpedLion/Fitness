package Controller;

import DAO.UserDAO;
import Model.User;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import jakarta.servlet.http.HttpSession;
/**
 * Servlet implementation class UserLoginServlet
 */
@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {

  
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String email = request.getParameter("email");
	    String password = request.getParameter("password");

	    UserDAO userDAO = new UserDAO();
	    User user = userDAO.loginUser(email, password);

	    if (user != null) {
	        HttpSession session = request.getSession();
	        session.setAttribute("userEmail", user.getEmail());
	        session.setAttribute("userName", user.getFullName());
	        session.setAttribute("isAdmin", user.isAdmin());

	        // Redirect based on role (optional)
	        if (user.isAdmin()) {
	            response.sendRedirect("Admin/AdminDashBoard.jsp");
	        } else {
	            response.sendRedirect("View/SaveProfile.jsp");
	        }
	    } else {
	        request.setAttribute("errorMessage", "Invalid email or password.");
	        RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
	        rd.forward(request, response);
	    }
	}

}
