package userinput;

import java.io.IOException;
import java.util.Set;

import DatabaseDAO.FetchAllUsersDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javabean.UserDataBean;

@WebServlet("/allUsersServlet")
public class AllUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userbean") == null) {
            response.sendRedirect(request.getContextPath() + "/public/html/userlogin.jsp");
            return;
        }

        // Fetching all users from DAO
        FetchAllUsersDAO fetchDao = new FetchAllUsersDAO();
        Set<UserDataBean> allUsers = fetchDao.getAllUsers();

        // Store the result in session
        session.setAttribute("allUsers", allUsers);

        // Redirect to the allUsers.jsp
        response.sendRedirect(request.getContextPath() + "/public/html/allUsers.jsp");
    }
}
