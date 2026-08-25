package DatabaseDAO;

//Checking user data in database and if it is present then returning the UserDataBean object
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import databaseoperation.DatabaseConnection;
import javabean.UserDataBean;

public class LoginDAO {

	//Method for storing user data in UserDataBean and returning the object
	public UserDataBean checkLogin(String usename, String password) {
		UserDataBean ub = null;

		try (Connection con = DatabaseConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(
						"Select * from skillexchangeusers Where username=? AND password=?")) {

			ps.setString(1, usename);
			ps.setString(2, password);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					ub = new UserDataBean();
					ub.setFname(rs.getString(1));
					ub.setLname(rs.getString(2));
					ub.setUsername(rs.getString(3));
					ub.setPass(rs.getString(4));
					ub.setEmail(rs.getString(5));
					ub.setPhno(rs.getLong(6));
					ub.setSkillToTeach(rs.getString(7));
					ub.setSkillToLearn(rs.getString(8));
					ub.setRating(rs.getInt(9));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return ub;
	}

}
