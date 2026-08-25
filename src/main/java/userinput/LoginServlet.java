package userinput;

import java.io.IOException;

import DatabaseDAO.LoginDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javabean.UserDataBean;

@SuppressWarnings("serial")

@WebServlet("/public/html/login")
public class LoginServlet extends HttpServlet{

	//Creating reference variable for Class
	LoginDAO ld=null;
	
	//Method for creating object before used
	@Override
	public void init()
	{
		ld= new LoginDAO();
	}
	

	//Method for handling post request and getting the data from HTML form
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		//Getting data from HTML form
		String username=req.getParameter("username");
		String password=req.getParameter("password");
		
		//Sending the username and password to LoginDAO to check data in DB and getting the User data in JavaBean[UserDataBean]
		UserDataBean ub=ld.checkLogin(username, password);
		
		//Checking data is present or not in DB
		if(ub!=null)
		{
			//Accessing ServletContext object reference
			ServletContext sct = req.getServletContext();
			sct.setAttribute("ubean", ub);
			
			//Creating new session
			HttpSession hs=req.getSession();
			
			//User bean adding to session
			hs.setAttribute("userbean", ub);
			
			//Forwarding request and response
			req.getRequestDispatcher("welcomePage.jsp").forward(req, res);
		}
		else
		{
			req.setAttribute("msg","<div class='login-fail'>Oops! Check your username or password.</div>");
			req.getRequestDispatcher("userlogin.jsp").forward(req, res);
		}
	}
	
	
	
}
