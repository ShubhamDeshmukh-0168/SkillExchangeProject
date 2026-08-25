package DatabaseDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;

import databaseoperation.DatabaseConnection;
import javabean.UserDataBean;

public class StartJourneyFormDAO {

	private static final String UPDATE_QUERY = "UPDATE skillexchangeusers SET email = ?, phonenumber = ?, skilltoteach = ?, skilltolearn = ?, rating = ? WHERE username = ?";

	public int storeData(UserDataBean ub) {
		int rowsAffected = 0;

		try (Connection con = DatabaseConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(UPDATE_QUERY)) {

			ps.setString(1, ub.getEmail());
			ps.setLong(2, ub.getPhno());
			ps.setString(3, ub.getSkillToTeach());
			ps.setString(4, ub.getSkillToLearn());
			ps.setInt(5, ub.getRating());
			ps.setString(6, ub.getUsername());

			rowsAffected = ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return rowsAffected;
	}
}
