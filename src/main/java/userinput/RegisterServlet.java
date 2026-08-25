package userinput;

import java.io.IOException;
import java.io.PrintWriter;

import DatabaseDAO.RegistrationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javabean.UserDataBean;

@SuppressWarnings("serial")

@WebServlet("/public/html/reg")
public class RegisterServlet extends HttpServlet {

	//Creating reference variable for Classes
	UserDataBean ub=null;
	RegistrationDAO au=null;
	
	//Method for creating object before used
	@Override
	public void init()
	{
		ub= new UserDataBean();
		au= new RegistrationDAO();
	}
	
	//Method for handling post request and getting the data from HTML form
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
	{
		//Getting data and storing into JavaBean class [UserDataBean]
		ub.setFname(req.getParameter("first-name"));
		ub.setLname(req.getParameter("last-name"));
		ub.setUsername(req.getParameter("username"));
		ub.setPass(req.getParameter("password"));
		
		//Storing data in Database using RegistrationDAO class and getting K value
		int result=au.addData(ub);
		
		//Setting the username for reuse in JSP 
		req.setAttribute("username",ub.getFname());
		
		//Checking data is stored or not in DB
		if(result>0)
		{
			req.setAttribute("msg", "<div class='reg-succces'>Registration Succeess Login now..</div>");
			req.getRequestDispatcher("userlogin.jsp").forward(req, res);
		}
		else
		{
			res.setContentType("text/html");
			
			PrintWriter pw=res.getWriter();
			pw.print("<div class='error-message'>[ Username taken! Try something more unique! ]</div>");
			req.getRequestDispatcher("registration.html").include(req, res);
		}
	}
}
