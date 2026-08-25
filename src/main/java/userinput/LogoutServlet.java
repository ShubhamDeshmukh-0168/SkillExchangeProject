package userinput;

import java.io.IOException;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@SuppressWarnings("serial")
@WebServlet("/logoutServlet")
public class LogoutServlet extends HttpServlet {
	
	
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException 
	{
		// Get the current session, if exists
		HttpSession session = req.getSession(false); // false means don't create new session if not exist

		if (session != null) 
		{
			session.invalidate(); // Invalidate the session to logout user
		}

		// Optionally remove ServletContext attribute if needed
		ServletContext context = getServletContext();
		context.removeAttribute("ubean");

	    // Forward to userlogin.jsp
		req.getRequestDispatcher("/index.html").forward(req, res);
	}
}
