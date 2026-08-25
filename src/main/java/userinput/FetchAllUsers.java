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

@WebServlet("/fetchAllUsers") // Here but in the application
public class FetchAllUsers extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		FetchAllUsersDAO fetchDao = new FetchAllUsersDAO();
		Set<UserDataBean> allUsers = fetchDao.getAllUsers();
		System.out.println(allUsers.size());

		HttpSession session = request.getSession();
		session.setAttribute("allUsers", allUsers);

		response.sendRedirect(request.getContextPath() + "/public/html/allUsers.jsp");
	}
}
