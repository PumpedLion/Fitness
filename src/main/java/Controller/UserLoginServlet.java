package Controller;

import DAO.UserDAO;
import Model.User;
import Utils.PasswordUtils;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Hash the input password before checking
        String hashedPassword = PasswordUtils.hashPassword(password);

        UserDAO userDAO = new UserDAO();
        User user = userDAO.loginUser(email, hashedPassword);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("isAdmin", user.isAdmin());

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
