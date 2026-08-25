package databaseoperation;

//Interface for Database information
//Values are read from environment variables first (recommended for EC2/production),
//falling back to local defaults so the app still runs out-of-the-box in dev.
public interface DatabaseInfo {

	//Database information (MySQL / Amazon RDS for MySQL)
	public static final String driver = "com.mysql.cj.jdbc.Driver";

	public static final String dbUrl = System.getenv().getOrDefault(
			"DB_URL", "jdbc:mysql://localhost:3306/skillexchange?useSSL=false&serverTimezone=UTC");

	public static final String dbUName = System.getenv().getOrDefault(
			"DB_USER", "root");

	public static final String dbPassword = System.getenv().getOrDefault(
			"DB_PASSWORD", "password");

}
