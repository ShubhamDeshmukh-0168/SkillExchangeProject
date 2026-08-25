package DatabaseDAO;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import databaseoperation.DatabaseConnection;

public class UserProfileImageDAO {

	private final static String sqlQuery = "SELECT PROFILEPIC FROM skillexchangeusers WHERE username = ?";

	// Returns the profile image bytes, or null if the user has none.
	// NOTE: reads the BLOB fully into memory before the connection is
	// returned to the pool - a Blob/InputStream tied to a closed
	// connection is no longer usable, so it can't be handed back "live".
	public byte[] getImageBytes(String userName) {

		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sqlQuery)) {

			ps.setString(1, userName);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					Blob blob = rs.getBlob("PROFILEPIC");
					if (blob != null) {
						byte[] bytes = blob.getBytes(1, (int) blob.length());
						blob.free();
						return bytes;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	// Convenience wrapper for callers that want a stream (e.g. to hand to
	// PreparedStatement.setBlob(InputStream)). Backed by an in-memory copy,
	// so it stays valid after this DAO call returns.
	public InputStream getImageInputStream(String userName) {
		byte[] bytes = getImageBytes(userName);
		return bytes == null ? null : new ByteArrayInputStream(bytes);
	}
}
