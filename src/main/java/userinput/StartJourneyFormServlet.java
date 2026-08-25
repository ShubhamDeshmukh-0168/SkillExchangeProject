package userinput;

import java.io.IOException;

import DatabaseDAO.StartJourneyFormDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javabean.UserDataBean;

@SuppressWarnings("serial")
@WebServlet("/startJourneyform")
public class StartJourneyFormServlet extends HttpServlet {

	private StartJourneyFormDAO sjf;

	@Override
	public void init() {
		sjf = new StartJourneyFormDAO();
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		try {
			String phoneStr = req.getParameter("phoneNumber");
			String email = req.getParameter("email");
			String skillToLearn = req.getParameter("skillToLearn");
			String skillToTeach = req.getParameter("skillToTeach");
			String ratingStr = req.getParameter("skillRating");

			if (phoneStr == null || email == null || skillToLearn == null || skillToTeach == null
					|| ratingStr == null) {

				// Redirecting to StartJourny form
				res.sendRedirect("startJourneyForm.html");

				return;
			}

			UserDataBean ub = new UserDataBean();
			ub.setPhno(Long.parseLong(phoneStr));
			ub.setEmail(email);
			ub.setSkillToLearn(skillToLearn);
			ub.setSkillToTeach(skillToTeach);
			ub.setRating(Integer.parseInt(ratingStr));

			ServletContext sct = req.getServletContext();
			UserDataBean sessionUser = (UserDataBean) sct.getAttribute("ubean");

			if (sessionUser == null) {
				res.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in.");
				return;
			}

			ub.setUsername(sessionUser.getUsername());
			System.out.println("Sir");
			int result = sjf.storeData(ub);
			if (result > 0) {
				res.sendRedirect(req.getContextPath() + "/fetchAllUsers");
			} else {
				res.getWriter().write("<h3>Failed to save user data. Try again.</h3>");
			}

		} catch (Exception e) {
			e.printStackTrace();
			res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}
}
