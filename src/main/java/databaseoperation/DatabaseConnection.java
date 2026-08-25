package databaseoperation;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

// Provides pooled Connections instead of a single shared static Connection.
//
// The original version created ONE Connection when the class loaded and
// handed the same object to every DAO forever. That mostly worked against a
// local database, but against a real network hop (e.g. Amazon RDS) that
// single connection eventually goes stale - idle timeouts, brief network
// blips, RDS maintenance/failover - and because the DAOs only
// e.printStackTrace() their errors, the whole app would silently stop
// reading/writing data until Tomcat was restarted.
//
// A connection pool (HikariCP) validates connections before handing them
// out and replaces dead ones automatically, which is the standard fix.
//
// IMPORTANT: every caller of getConnection() MUST close() the Connection it
// gets back (use try-with-resources) - that returns it to the pool. Calling
// close() no longer really closes the network connection.
public class DatabaseConnection {

	private static final HikariDataSource dataSource;

	private DatabaseConnection() {}

	static {
		HikariConfig config = new HikariConfig();
		config.setDriverClassName(DatabaseInfo.driver);
		config.setJdbcUrl(DatabaseInfo.dbUrl);
		config.setUsername(DatabaseInfo.dbUName);
		config.setPassword(DatabaseInfo.dbPassword);

		// Keep the pool modest - this is a small app on a small instance.
		config.setMaximumPoolSize(10);
		config.setMinimumIdle(2);

		// Detect/replace stale connections rather than handing out a dead one.
		config.setConnectionTestQuery("SELECT 1");
		config.setMaxLifetime(25 * 60 * 1000L);   // recycle every 25 min
		config.setIdleTimeout(10 * 60 * 1000L);   // close idle connections after 10 min
		config.setConnectionTimeout(10 * 1000L);  // fail fast instead of hanging a request

		config.setPoolName("SkillExchangePool");

		dataSource = new HikariDataSource(config);
	}

	// Borrow a Connection from the pool. Callers MUST close() it (ideally via
	// try-with-resources) when done so it goes back to the pool.
	public static Connection getConnection() throws SQLException {
		return dataSource.getConnection();
	}
}
