package userinput;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import databaseoperation.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/getUserImage")
public class GetUserImage extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");

        String query = "SELECT profilepic FROM skillexchangeusers WHERE username = ?";
        try (
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query)
        ) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Blob imageBlob = rs.getBlob("profilepic");
                if (imageBlob != null) {
                    response.setContentType("image/jpeg"); // or image/png depending on your upload
                    InputStream is = imageBlob.getBinaryStream();
                    byte[] buffer = new byte[1024];
                    int bytesRead = -1;

                    while ((bytesRead = is.read(buffer)) != -1) {
                        response.getOutputStream().write(buffer, 0, bytesRead);
                    }
                    is.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
